import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../BottomNav/controllers/bottom_nav_controller.dart';
import '../controllers/reels_for_worshipers_controller.dart';

class ReelVideoPlayer extends StatefulWidget {
  final String url;
  final int leaderId;
  final String? leaderName;
  final String? leaderPhoto;
  final String? caption;
  final bool isVerified;

  const ReelVideoPlayer({
    super.key,
    required this.url,
    required this.leaderId,
    this.leaderName,
    this.leaderPhoto,
    this.caption,
    this.isVerified = true,
  });

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late final BetterPlayerController _controller;

  final BottomNavController navController = Get.find();
  final ReelsForWorshipersController reelsController = Get.find();

  bool _pausedByUser = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
        fit: BoxFit.cover,
        autoDispose: false,
        handleLifecycle: true,
        controlsConfiguration:
            const BetterPlayerControlsConfiguration(showControls: false),
      ),
      betterPlayerDataSource: BetterPlayerDataSource.network(widget.url),
    );

    /// Bottom-nav sync ONLY
    ever(navController.index, (_) {
      if (navController.index.value == 2 && !_pausedByUser) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  void _togglePlayPause() {
    if (_controller.isPlaying() ?? false) {
      _controller.pause();
      _pausedByUser = true;
    } else {
      _controller.play();
      _pausedByUser = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bottomSafe = MediaQuery.of(context).padding.bottom;
    const uploaderBottom = 180.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        /// 🎥 VIDEO (NO GESTURES)
        IgnorePointer(
          child: BetterPlayer(controller: _controller),
        ),

        /// ▶️ EXPLICIT PLAY / PAUSE BUTTON (CENTER)
        Center(
          child: Material(
            color: Colors.black.withOpacity(0.35),
            shape: const CircleBorder(),
            child: IconButton(
              iconSize: 90,
              icon: Icon(
                (_controller.isPlaying() ?? false)
                    ? Iconsax.pause_circle5
                    : Iconsax.play_circle5,
                color: Colors.white,
              ),
              onPressed: _togglePlayPause,
            ),
          ),
        ),

        /// 👤 UPLOADER INFO (BLOCKS PAGEVIEW, ALLOWS FOLLOW)
        Positioned(
          left: 16,
          right: 16,
          bottom: uploaderBottom + bottomSafe,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: (_) {}, // 🔥 stops PageView stealing taps
            child: Material(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    backgroundImage: widget.leaderPhoto != null
                        ? NetworkImage(widget.leaderPhoto!)
                        : null,
                    child: widget.leaderPhoto == null
                        ? const Icon(Iconsax.user, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.leaderName ?? "Leader",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Iconsax.verify5,
                                color: Colors.blueAccent,
                                size: 16,
                              ),
                            ],
                            const SizedBox(width: 10),

                            /// ✅ FOLLOW BUTTON (NOW FIXED)
                            Obx(() {
                              final isFollowing = reelsController
                                  .isFollowing(widget.leaderId);

                              return InkWell(
                                borderRadius:
                                    BorderRadius.circular(30),
                                onTap: () => reelsController
                                    .followLeader(widget.leaderId),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? Colors.white
                                        : Colors.white
                                            .withOpacity(0.35),
                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    isFollowing
                                        ? "Following"
                                        : "Follow",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isFollowing
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),

                        if (widget.caption != null &&
                            widget.caption!.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.caption!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
