import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/data/model/follower_model.dart';
import 'package:flutter/material.dart';

class FollowerTile extends StatelessWidget {
  final FollowerModel follower;

  const FollowerTile({
    super.key,
    required this.follower,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    // Faith chip color based on theme (more vibrant but still elegant)
    final chipBg = scheme.brightness == Brightness.light
        ? scheme.primary.withOpacity(0.12)
        : scheme.primary.withOpacity(0.25);

    final chipTextColor = scheme.brightness == Brightness.light
        ? scheme.primary
        : scheme.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        color: scheme.surface,
        child: InkWell(
          onTap: () {
            // Optional: Open profile or chat when tapped
            // Get.toNamed(Routes.PROFILE, arguments: follower.id);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// Profile Avatar with subtle ring effect in light/dark
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: scheme.surfaceVariant,
                    backgroundImage: follower.profilePhotoUrl != null
                        ? NetworkImage(follower.profilePhotoUrl!)
                        : null,
                    child: follower.profilePhotoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 34,
                            color: scheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 16),

                /// Name + Faith chip column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        follower.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      if (follower.faith != null && follower.faith!.trim().isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: chipBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: scheme.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            follower.faith!,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: chipTextColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Removed the 3 dots completely as requested
              ],
            ),
          ),
        ),
      ),
    );
  }
}