import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/leaders_chat_list_controller.dart';

class LeadersChatListView extends GetView<LeadersChatListController> {
  const LeadersChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search conversations...",
                prefixIcon: Icon(Icons.search, color: scheme.onSurfaceVariant),
                filled: true,
                fillColor: scheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Conversation List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 80, color: scheme.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text(
                        "No conversations yet",
                        style: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.conversations.length,
                itemBuilder: (context, index) {
                  final c = controller.conversations[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      elevation: 1,
                      shadowColor: scheme.shadow.withOpacity(0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          print("Tapped on conversation with ${c.name}");
                          print("Conversation ID: ${c.conversationId}");
                          print("Other User ID: ${c.otherUserId}");
                          print("Other Profile url: ${c.profilePhoto}");
                          Get.toNamed(
                            Routes.LEADERS_CHAT_DETAIL,
                            arguments: {
                              'otherUserId': c.otherUserId,
                              'conversationId': c.conversationId,
                              'name': c.name,
                              'profilePhoto': c.profilePhoto,
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Avatar with online indicator
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: c.profilePhoto != null
                                        ? NetworkImage(c.profilePhoto!)
                                        : null,
                                    backgroundColor: scheme.surfaceVariant,
                                    child: c.profilePhoto == null
                                        ? Icon(Icons.person, color: scheme.onSurfaceVariant)
                                        : null,
                                  ),
                                  if (c.isOnline)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: scheme.surface, width: 2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 16),

                              // Name + Last Message + Faith Chip
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: scheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      c.lastMessage ?? "Start a conversation",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 8),

                                    // Faith Chip
                                   
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}