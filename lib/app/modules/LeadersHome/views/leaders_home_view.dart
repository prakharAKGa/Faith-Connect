import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../components/follower_tile.dart';
import '../components/leader_post_card.dart';
import '../controllers/leaders_home_controller.dart';

class LeadersHomeView extends GetView<LeadersHomeController> {
  const LeadersHomeView({super.key});

  Future<void> _handleLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await TokenStorage().clear(); // Clear token, role, userId, theme preference
      Get.offAllNamed(Routes.LOGIN); // Or Routes.INITIAL - adjust to your login route
      Get.snackbar("Logged Out", "See you soon!", backgroundColor: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Home Feed",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          // Theme toggle button
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
                color: scheme.onBackground,
                size: 26,
              ),
              tooltip: themeController.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
              onPressed: themeController.toggleTheme,
            ),
          ),

          // Profile button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: scheme.surfaceVariant,
                child: Icon(
                  Iconsax.user,
                  color: scheme.onSurface,
                  size: 22,
                ),
              ),
            ),
          ),

          // Logout button
          IconButton(
            icon: const Icon(Iconsax.logout, size: 24),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 8),

          /// ───── POSTS / FOLLOWERS TAB ─────
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _Tab(
                      label: "My Posts",
                      selected: controller.selectedTab.value == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    _Tab(
                      label: "Followers",
                      selected: controller.selectedTab.value == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          /// ───── CONTENT ─────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                color: scheme.primary,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.selectedTab.value == 0
                      ? controller.posts.length
                      : controller.followers.length,
                  itemBuilder: (context, index) {
                    return controller.selectedTab.value == 0
                        ? LeaderPostCard(
                            post: controller.posts[index],
                          )
                        : FollowerTile(
                            follower: controller.followers[index],
                          );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// ───── TAB BUTTON ─────
class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : scheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}