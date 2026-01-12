import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/leader_card.dart';
import '../controllers/leadersfor_worshiper_controller.dart';

class LeadersforWorshiperView extends GetView<LeadersforWorshiperController> {
  const LeadersforWorshiperView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Religious Leaders")),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// Tabs
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _Tab(
                    label: "My Leaders",
                    selected: controller.selectedTab.value == 0,
                    onTap: () => controller.changeTab(0),
                  ),
                  _Tab(
                    label: "Explore",
                    selected: controller.selectedTab.value == 1,
                    onTap: () => controller.changeTab(1),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          /// Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: "Search leader",
                filled: true,
                fillColor: scheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: controller.fetchCurrentTab,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.filteredLeaders.length,
                  itemBuilder: (context, index) {
                    final leader = controller.filteredLeaders[index];
                    return LeaderCard(
                      leader: leader,
                      isExplore: controller.selectedTab.value == 1,
                      onFollowTap: () =>
                          controller.toggleFollow(leader),
                      onMessageTap: () =>
                          controller.openChat(leader),
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
            color: selected ? scheme.primary : scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
