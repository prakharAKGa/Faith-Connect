import 'package:faithconnect/app/modules/PostDetails/controllers/post_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PostDetailsView extends GetView<PostDetailsController> {
  const PostDetailsView({super.key});

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.post.leaderName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: scheme.onBackground,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: controller.post.profilePhotoUrl != null
                  ? NetworkImage(controller.post.profilePhotoUrl!)
                  : null,
              backgroundColor: scheme.surfaceVariant,
              child: controller.post.profilePhotoUrl == null
                  ? Icon(Iconsax.user, color: scheme.onSurfaceVariant)
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Post Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: controller.post.profilePhotoUrl != null
                          ? NetworkImage(controller.post.profilePhotoUrl!)
                          : null,
                      backgroundColor: scheme.surfaceVariant,
                      child: controller.post.profilePhotoUrl == null
                          ? Icon(Iconsax.user, color: scheme.onSurfaceVariant, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.post.leaderName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            "Posted • ${_formatTimeAgo(controller.post.createdAt)}",
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Caption
                Text(
                  controller.post.caption ?? "",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                    color: scheme.onSurface,
                  ),
                ),

                const SizedBox(height: 24),

                // Media (Image)
                if (controller.post.mediaType == "IMAGE" && controller.post.mediaUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.network(
                        controller.post.mediaUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 300,
                            color: scheme.surfaceVariant,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: scheme.surfaceVariant,
                            child: const Center(
                              child: Icon(Iconsax.image, size: 60, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 28),

                // Action Buttons (Like, Comment, Share)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => _ActionButton(
                        icon: controller.isLiked.value
                            ? Iconsax.heart5
                            : Iconsax.heart,
                        count: controller.likesCount.value,
                        color: controller.isLiked.value
                            ? Colors.redAccent
                            : scheme.onSurfaceVariant,
                        onTap: controller.likePost,
                      ),
                    ),
                    _ActionButton(
                      icon: Iconsax.message_text,
                      count: controller.post.commentsCount,
                      color: scheme.onSurfaceVariant,
                      onTap: () {}, // TODO: Scroll to comments or open full comments
                    ),
                    Obx(
                      () => _ActionButton(
                        icon: Iconsax.repeat,
                        count: controller.sharesCount.value,
                        color: scheme.onSurfaceVariant,
                        onTap: controller.sharePost,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 40, thickness: 1),

                // Comments Section Header
                Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.comments.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Iconsax.message_question, size: 60, color: scheme.onSurfaceVariant),
                            const SizedBox(height: 16),
                            Text(
                              "No comments yet",
                              style: TextStyle(
                                fontSize: 16,
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Be the first to share your thoughts!",
                              style: TextStyle(
                                fontSize: 14,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.comments.map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: c.commenterPhoto != null
                                  ? NetworkImage(c.commenterPhoto!)
                                  : null,
                              backgroundColor: scheme.surfaceVariant,
                              child: c.commenterPhoto == null
                                  ? Icon(Iconsax.user, color: scheme.onSurfaceVariant, size: 26)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c.commenterName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "• ${_formatTimeAgo(c.createdAt)}",
                                        style: TextStyle(
                                          color: scheme.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.text,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: scheme.onSurface,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),

          // Sticky Comment Input
          SafeArea(
            bottom: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(
                  top: BorderSide(color: scheme.surface, width: 1),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: scheme.surfaceVariant,
                    child: Icon(Iconsax.user, color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.commentCtrl,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                        filled: true,
                        fillColor: scheme.surfaceVariant.withOpacity(0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Iconsax.send_1, color: scheme.primary, size: 28),
                    onPressed: controller.addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
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