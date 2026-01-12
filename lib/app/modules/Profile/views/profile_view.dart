import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final p = controller.profile.value!;
        final s = p.stats;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ───────── HEADER ─────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage:
                        p.profilePhoto != null ? NetworkImage(p.profilePhoto!) : null,
                    child: p.profilePhoto == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (p.faith != null)
                    Text(
                      p.faith!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (p.bio != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      p.bio!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ───────── STATS ─────────
            Card(
              color: scheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: controller.isLeader
                    ? _LeaderStats(stats: s)
                    : _WorshiperStats(stats: s),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// ───────── LEADER STATS ─────────
class _LeaderStats extends StatelessWidget {
  final stats;
  const _LeaderStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem("Posts", stats.totalPosts ?? 0),
        _StatItem("Reels", stats.totalReels ?? 0),
        _StatItem("Followers", stats.totalFollowers ?? 0),
      ],
    );
  }
}

/// ───────── WORSHIPER STATS ─────────
class _WorshiperStats extends StatelessWidget {
  final stats;
  const _WorshiperStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem("Following", stats.totalFollowing ?? 0),
        _StatItem("Likes", stats.totalLikes ?? 0),
        _StatItem("Comments", stats.totalComments ?? 0),
      ],
    );
  }
}

/// ───────── STAT ITEM ─────────
class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
