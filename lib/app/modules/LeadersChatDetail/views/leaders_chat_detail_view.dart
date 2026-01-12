import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:faithconnect/app/modules/LeadersChatDetail/components/leaders_chat_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/leaders_chat_detail_controller.dart';

class LeadersChatDetailView extends GetView<LeadersChatDetailController> {
  const LeadersChatDetailView({super.key});

  String formatTime(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return "$h:$m $ampm";
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (controller.showEmoji.value) {
          controller.showEmoji.value = false;
          return false;
        }
        controller.socket.disconnect();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true, // Important for keyboard

        /// ───────── APP BAR ─────────
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
          title: Obx(() {
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: scheme.surfaceVariant,
                  backgroundImage: controller.userPhoto.value != null
                      ? NetworkImage(controller.userPhoto.value!)
                      : null,
                  child: controller.userPhoto.value == null
                      ? Icon(Icons.person, color: scheme.onSurfaceVariant)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        controller.isTyping.value
                            ? "typing…"
                            : controller.isUserOnline.value
                                ? "online"
                                : "offline",
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.isTyping.value
                              ? Colors.green
                              : scheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),

        /// ───────── BODY ─────────
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const LeadersChatShimmer();
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    itemCount: controller.messages.length,
                    itemBuilder: (_, i) {
                      final m = controller.messages.reversed.toList()[i];
                      final isMe = m.senderId == controller.myUserId;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: scheme.surfaceVariant,
                                backgroundImage:
                                    controller.userPhoto.value != null
                                        ? NetworkImage(
                                            controller.userPhoto.value!)
                                        : null,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    14, 10, 14, 8),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? scheme.primary
                                      : scheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      m.message,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isMe
                                            ? Colors.white
                                            : scheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formatTime(m.createdAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isMe
                                                ? Colors.white70
                                                : scheme.onSurface
                                                    .withOpacity(0.6),
                                          ),
                                        ),
                                        if (isMe) ...[
                                          const SizedBox(width: 6),
                                          messageStatusIcon(m.status),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              // ── Input Bar + Emoji Picker ──
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Emoji toggle button
                          IconButton(
                            icon: Icon(
                              controller.showEmoji.value
                                  ? Icons.keyboard
                                  : Icons.emoji_emotions_outlined,
                              color: scheme.primary,
                            ),
                            onPressed: () {
                              if (controller.showEmoji.value) {
                                controller.showEmoji.value = false;
                                FocusScope.of(context)
                                    .requestFocus(controller.focusNode);
                              } else {
                                controller.showEmoji.value = true;
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),

                          Expanded(
                            child: TextField(
                              controller: controller.textCtrl,
                              focusNode: controller.focusNode,
                              onChanged: controller.onTyping,
                              decoration: const InputDecoration(
                                hintText: "Type a message…",
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: controller.sendMessage,
                          ),
                        ],
                      ),
                    ),

                    // Emoji Picker - appears above input, inside SafeArea
                    if (controller.showEmoji.value)
                      SizedBox(
                        height: 280,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            controller.insertEmoji(emoji.emoji);
                          },
                          config: Config(
                            // columns: 7,
                            // emojiSizeMax: 28,
                            // bgColor: scheme.background,
                            // indicatorColor: scheme.primary,
                            // enableSkinTones: true,
                            // recentTabBehavior: RecentTabBehavior.RECENT,
                            // recentsLimit: 28,
                            // categoryIcons: const CategoryIcons(),
                            // buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
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
}

Widget messageStatusIcon(String status) {
  switch (status) {
    case 'PENDING':
      return const Icon(Icons.access_time, size: 14, color: Colors.white70);
    case 'SENT':
      return const Icon(Icons.check, size: 14, color: Colors.white70);
    case 'DELIVERED':
      return const Icon(Icons.done_all, size: 14, color: Colors.white70);
    case 'SEEN':
      return const Icon(Icons.done_all, size: 14, color: Colors.greenAccent);
    default:
      return const SizedBox();
  }
}