import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onShare,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    if (widget.post.mediaUrl != null &&
        widget.post.mediaUrl!.trim().isNotEmpty &&
        widget.post.mediaType == "VIDEO") {
      _videoController = VideoPlayerController.network(widget.post.mediaUrl!)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        })
        ..setLooping(true)
        ..play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _openDetails() {
    Get.toNamed(
      Routes.POST_DETAILS,
      arguments: widget.post,
    );
  }

  bool get _hasMedia =>
      widget.post.mediaUrl != null && widget.post.mediaUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GestureDetector(
      onTap: _openDetails,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Card(
          elevation: 4,
          shadowColor: scheme.shadow.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media
              if (_hasMedia)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: widget.post.mediaType == "IMAGE"
                      ? Image.network(
                          widget.post.mediaUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 280,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 280,
                              color: scheme.surfaceVariant,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 280,
                              color: scheme.errorContainer.withOpacity(0.6),
                              child: const Center(
                                child: Icon(Iconsax.image, size: 64, color: Colors.white70),
                              ),
                            );
                          },
                        )
                      : _buildVideoPlayer(),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leader + Time
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: widget.post.profilePhotoUrl != null
                              ? NetworkImage(widget.post.profilePhotoUrl!)
                              : null,
                          backgroundColor: scheme.surfaceVariant,
                          child: widget.post.profilePhotoUrl == null
                              ? Icon(Iconsax.user, color: scheme.onSurfaceVariant, size: 28)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.leaderName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                _timeAgo(widget.post.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Caption
                    if (widget.post.caption.isNotEmpty)
                      Text(
                        widget.post.caption,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          fontSize: 16,
                          color: scheme.onSurface,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Iconsax.heart,
                          activeIcon: Iconsax.heart5,
                          count: widget.post.likesCount,
                          color: Colors.redAccent,
                          isActive: widget.post.isLiked,  // ← Uses isLiked from model
                          onTap: widget.onLike,
                        ),
                        _ActionButton(
                          icon: Iconsax.message_text,
                          activeIcon: Iconsax.message_text5,
                          count: widget.post.commentsCount,
                          color: Colors.blueAccent,
                          isActive: false,
                          onTap: _openDetails,
                        ),
                        _ActionButton(
                          icon: Iconsax.repeat,
                          activeIcon: Iconsax.repeat5,
                          count: widget.post.sharesCount,
                          color: Colors.greenAccent,
                          isActive: false,
                          onTap: widget.onShare,
                        ),
                        _ActionButton(
                          icon: Iconsax.save_add,
                          activeIcon: Iconsax.save_add5,
                          count: widget.post.savesCount,
                          color: Colors.purpleAccent,
                          isActive: false,
                          onTap: () {}, // TODO: Add save logic later
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final scheme = Theme.of(context).colorScheme;

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        height: 280,
        color: scheme.surfaceVariant,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final int count;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.activeIcon,
    required this.count,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 26,
              color: isActive ? color : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}