import 'package:faithconnect/app/core/config/token_storage.dart';
import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../components/feed_tab_button.dart';
import '../components/post_card.dart';
import '../controllers/worshiper_home_controller.dart';

class WorshiperHomeView extends GetView<WorshiperHomeController> {
  const WorshiperHomeView({super.key});

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
      await TokenStorage().clear(); // Clear all secure storage (token, role, userId, theme)
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
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, size: 24),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Home Feed",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          // Theme toggle button (modern iconsax)
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
                size: 24,
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

          /// ───────── EXPLORE / FOLLOWING TABS ─────────
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
                    FeedTabButton(
                      label: "Explore",
                      selected: controller.selectedTab.value == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    FeedTabButton(
                      label: "Following",
                      selected: controller.selectedTab.value == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          /// ───────── FEED LIST ─────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.document_text,
                        size: 80,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No posts available",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Check back later or follow more leaders",
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshFeed,
                color: scheme.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];

                    return PostCard(
                      post: post,
                      onLike: () => controller.like(post),
                      onShare: () => controller.share(post),
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