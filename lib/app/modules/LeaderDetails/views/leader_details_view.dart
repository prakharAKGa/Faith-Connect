import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/modules/ReelsForWorshipers/components/reel_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
            // Modern floating profile header
            SliverAppBar(
              expandedHeight: 340,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            scheme.primary,
                            scheme.primary.withOpacity(0.8),
                            scheme.background.withOpacity(0.95),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight + 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: scheme.surfaceVariant,
                              backgroundImage: leader.profilePhotoUrl != null
                                  ? NetworkImage(leader.profilePhotoUrl!)
                                  : null,
                              child: leader.profilePhotoUrl == null
                                  ? Icon(Icons.person, size: 80, color: scheme.onSurfaceVariant)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            leader.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            leader.faith,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 8, top: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.message_text, color: Colors.white, size: 22),
                    onPressed: controller.openChat,
                  ),
                ),
              ],
            ),

            // Bio + Stats + Buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leader.bio?.isNotEmpty ?? false) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: appColors.divider.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          leader.bio!,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scheme.surface.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: appColors.divider.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem("Followers", leader.stats.totalFollowers, scheme),
                          _StatItem("Posts", leader.stats.totalPosts, scheme),
                          _StatItem("Reels", leader.stats.totalReels, scheme),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final isFollowing = controller.leader.value?.isFollowing ?? false;
                            return ElevatedButton.icon(
                              onPressed: controller.toggleFollow,
                              icon: Icon(
                                isFollowing ? Iconsax.verify5 : Iconsax.user_add,
                                size: 20,
                              ),
                              label: Text(
                                isFollowing ? "Following" : "Follow",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFollowing ? scheme.surfaceVariant : scheme.primary,
                                foregroundColor: isFollowing ? scheme.onSurface : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.openChat,
                            icon: const Icon(Iconsax.message_text, size: 20),
                            label: const Text(
                              "Message",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: scheme.primary,
                              side: BorderSide(color: scheme.primary, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Pinned Tab Bar (fixed version)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                child: Container(
                  color: scheme.background,
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: TabBar(
                      controller: controller.tabController,
                      labelColor: scheme.primary,
                      unselectedLabelColor: scheme.onSurfaceVariant,
                      indicatorColor: scheme.primary,
                      indicatorWeight: 4,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      tabs: const [
                        Tab(text: "Posts"),
                        Tab(text: "Reels"),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // POSTS TAB
                  leader.posts.isEmpty
                      ? Center(child: Text("No posts yet", style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 18)))
                      : RefreshIndicator(
                          onRefresh: controller.refreshProfile,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: leader.posts.length,
                            itemBuilder: (_, i) {
                              final post = leader.posts[i];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 20),
                                elevation: 3,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage: leader.profilePhotoUrl != null
                                                ? NetworkImage(leader.profilePhotoUrl!)
                                                : null,
                                            backgroundColor: scheme.surfaceVariant,
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                leader.name,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                              ),
                                              Text(
                                                _timeAgo(post.createdAt),
                                                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (post.caption != null && post.caption!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Text(
                                          post.caption!,
                                          style: const TextStyle(fontSize: 16, height: 1.5),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    _buildEngagementRow(
                                      post.likesCount ?? 0,
                                      post.commentsCount ?? 0,
                                      post.sharesCount ?? 0,
                                      scheme,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                  // REELS TAB
                  leader.reels.isEmpty
                      ? Center(child: Text("No reels yet", style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 18)))
                      : RefreshIndicator(
                          onRefresh: controller.refreshProfile,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 9 / 16,
                            ),
                            itemCount: leader.reels.length,
                            itemBuilder: (_, i) {
                              final reel = leader.reels[i];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => Scaffold(
                                        backgroundColor: Colors.black,
                                        body: Center(
                                          child: ReelVideoPlayer(
                                            url: reel.videoUrl,
                                            leaderId: leader.id,
                                            leaderName: leader.name,
                                            leaderPhoto: leader.profilePhotoUrl,
                                            caption: reel.caption,
                                          ),
                                        ),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          child: const Center(
                                            child: Icon(
                                              Icons.play_circle_fill_rounded,
                                              size: 50,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.9),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (reel.caption != null && reel.caption!.isNotEmpty)
                                                  Text(
                                                    reel.caption!,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                Text(
                                                  _timeAgo(reel.createdAt),
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: scheme.onBackground,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
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
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// Fixed & Safe Sliver Tab Bar Delegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTabBarDelegate({required this.child});

  @override
  double get minExtent => 56.0;
  @override
  double get maxExtent => 56.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}