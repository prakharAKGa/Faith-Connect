import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/modules/ReelsForWorshipers/components/reel_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/leader_details_controller.dart';

class LeaderDetailsView extends GetView<LeaderDetailsController> {
  const LeaderDetailsView({super.key});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildEngagementRow(int likes, int comments, int shares, ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _EngagementItem(Icons.favorite, likes, scheme),
        _EngagementItem(Icons.comment, comments, scheme),
        _EngagementItem(Icons.share, shares, scheme),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: scheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8, top: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Get.back(),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: scheme.primary));
        }

        final leader = controller.leader.value;
        if (leader == null) {
          return Center(
            child: Text("Leader not found", style: TextStyle(color: scheme.onBackground)),
          );
        }

        return CustomScrollView(
          slivers: [
            // ─── Profile Header ───
            SliverToBoxAdapter(
              child: Container(
                height: 340,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.primary,
                      scheme.primary.withOpacity(0.75),
                      scheme.background.withOpacity(0.92),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 3.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: scheme.surfaceVariant,
                        backgroundImage: leader.profilePhotoUrl != null
                            ? NetworkImage(leader.profilePhotoUrl!)
                            : null,
                        child: leader.profilePhotoUrl == null
                            ? Icon(Icons.person, size: 70, color: scheme.onSurfaceVariant)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      leader.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      leader.faith,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ─── Bio + Stats + Buttons ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leader.bio?.isNotEmpty ?? false) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: appColors.divider),
                        ),
                        child: Text(
                          leader.bio!,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem("Followers", leader.stats.totalFollowers, scheme),
                        _StatItem("Posts", leader.stats.totalPosts, scheme),
                        _StatItem("Reels", leader.stats.totalReels, scheme),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final isFollowing = controller.leader.value?.isFollowing ?? false;
                            return FilledButton(
                              onPressed: controller.toggleFollow,
                              style: FilledButton.styleFrom(
                                backgroundColor: isFollowing ? scheme.surfaceVariant : scheme.primary,
                                foregroundColor: isFollowing ? scheme.onSurface : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                isFollowing ? "Following" : "Follow",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.openChat,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: scheme.primary,
                              side: BorderSide(color: scheme.primary),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              "Message",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── Pinned Tabs ───
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                child: Container(
                  color: scheme.background,
                  child: TabBar(
                    controller: controller.tabController,
                    labelColor: scheme.primary,
                    unselectedLabelColor: scheme.onSurfaceVariant,
                    indicatorColor: scheme.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    tabs: const [
                      Tab(text: "Posts"),
                      Tab(text: "Reels"),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Tab Content ───
            SliverFillRemaining(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // POSTS TAB
                  leader.posts.isEmpty
                      ? Center(child: Text("No posts yet", style: TextStyle(color: scheme.onSurfaceVariant)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: leader.posts.length,
                          itemBuilder: (_, i) {
                            final post = leader.posts[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundImage: leader.profilePhotoUrl != null
                                              ? NetworkImage(leader.profilePhotoUrl!)
                                              : null,
                                          backgroundColor: scheme.surfaceVariant,
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              leader.name,
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                            ),
                                            Text(
                                              _timeAgo(post.createdAt),
                                              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (post.caption != null && post.caption!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: Text(
                                        post.caption!,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  _buildEngagementRow(
                                    post.likesCount ?? 0,
                                    post.commentsCount ?? 0,
                                    post.sharesCount ?? 0,
                                    scheme,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            );
                          },
                        ),

                  // REELS TAB - Vertical Grid (Instagram style)
                  leader.reels.isEmpty
                      ? Center(child: Text("No reels yet", style: TextStyle(color: scheme.onSurfaceVariant)))
                      : GridView.builder(
                          padding: const EdgeInsets.all(6),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 9 / 16, // vertical video ratio
                          ),
                          itemCount: leader.reels.length,
                          itemBuilder: (_, i) {
                            final reel = leader.reels[i];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => Scaffold(
                                      backgroundColor: Colors.black,
                                      body: Center(child: ReelVideoPlayer(url: reel.videoUrl,leaderId: reel.id,)),
                                    ));
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_fill_rounded,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.85),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (reel.caption != null && reel.caption!.isNotEmpty)
                                            Text(
                                              reel.caption!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          Text(
                                            _timeAgo(reel.createdAt),
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.75),
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          _buildEngagementRow(
                                            reel.likesCount ?? 0,
                                            reel.commentsCount ?? 0,
                                            reel.sharesCount ?? 0,
                                            scheme,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final ColorScheme scheme;

  const _StatItem(this.label, this.value, this.scheme);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: scheme.onBackground,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EngagementItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final ColorScheme scheme;

  const _EngagementItem(this.icon, this.count, this.scheme);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 13,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTabBarDelegate({required this.child});

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 1.5 : 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_) => false;
}