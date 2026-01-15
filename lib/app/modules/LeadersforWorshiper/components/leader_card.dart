import 'package:faithconnect/app/data/model/leader_model.dart';
import 'package:faithconnect/app/modules/LeadersforWorshiper/components/faith_chip.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderCard extends StatelessWidget {
  final LeaderModel leader;
  final bool isExplore;
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;

  const LeaderCard({
    super.key,
    required this.leader,
    required this.isExplore,
    required this.onFollowTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.LEADER_DETAILS,
        arguments: leader.id,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: scheme.surfaceVariant,
                backgroundImage: leader.profilePhotoUrl != null
                    ? NetworkImage(leader.profilePhotoUrl!)
                    : null,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leader.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FaithChip(leader.faith),
                    if (leader.bio != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        leader.bio!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: isExplore ? onFollowTap : onMessageTap,
                  style: ElevatedButton.styleFrom(
                    // Common style for both buttons
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // Dynamic background & text color
                    backgroundColor: isExplore
                        ? (leader.isFollowing
                            ? scheme.surfaceVariant
                            : scheme.primary)
                        : scheme.primary,
                    foregroundColor: isExplore
                        ? (leader.isFollowing
                            ? scheme.onSurface
                            : Colors.white)
                        : Colors.white, // Message button always white text
                  ),
                  child: Text(
                    isExplore
                        ? (leader.isFollowing ? 'Following' : 'Follow')
                        : 'Message',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}