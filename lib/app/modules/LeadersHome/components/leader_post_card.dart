import 'package:faithconnect/app/data/model/post_model.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderPostCard extends StatelessWidget {
  final PostModel post;

  const LeaderPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigate to Post Details page when card is tapped
          Get.toNamed(
            Routes.POST_DETAILS,
            arguments: post,
          );
        },
        child: Card(
          elevation: 3,
          shadowColor: scheme.shadow.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media (top) - full width, rounded
              if (post.mediaUrl != null && post.mediaUrl!.trim().isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      post.mediaUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: scheme.surfaceVariant,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: scheme.errorContainer.withOpacity(0.6),
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.white70),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Content area
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Caption
                    Text(
                      post.caption,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Stats row - modern & colorful
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          icon: Icons.favorite_border_rounded,
                          count: post.likesCount,
                          color: Colors.redAccent,
                        ),
                        _StatItem(
                          icon: Icons.comment_outlined,
                          count: post.commentsCount,
                          color: Colors.blueAccent,
                        ),
                        _StatItem(
                          icon: Icons.share_outlined,
                          count: post.sharesCount,
                          color: Colors.greenAccent,
                        ),
                        _StatItem(
                          icon: Icons.bookmark_border_rounded,
                          count: post.savesCount,
                          color: Colors.purpleAccent,
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

  Widget _StatItem({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: color.withOpacity(0.85),
        ),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}