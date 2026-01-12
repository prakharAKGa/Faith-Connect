import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:faithconnect/app/modules/LeadersChatDetail/components/leaders_chat_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/worshiper_chat_with_leaders_controller.dart';

class WorshiperChatWithLeadersView
    extends GetView<WorshiperChatWithLeadersController> {
  const WorshiperChatWithLeadersView({super.key});

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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: Get.back,
          ),
          title: Obx(() {
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: scheme.surfaceVariant,
                  backgroundImage: controller.leaderPhoto.value != null
                      ? NetworkImage(controller.leaderPhoto.value!)
                      : null,
                  child: controller.leaderPhoto.value == null
                      ? Icon(Icons.person, color: scheme.onSurfaceVariant)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.leaderName.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        controller.isTyping.value
                            ? "typing…"
                            : controller.isLeaderOnline.value
                                ? "online"
                                : "offline",
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.isTyping.value
                              ? Colors.greenAccent
                              : Colors.white70,
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scheme.primary.withOpacity(0.06),
                scheme.background,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                /// Space for transparent AppBar
                SizedBox(
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),

                /// ───────── MESSAGES ─────────
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
                                      controller.leaderPhoto.value != null
                                          ? NetworkImage(
                                              controller.leaderPhoto.value!)
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

                /// ───────── INPUT BAR + EMOJI PICKER ─────────
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Input field
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            // Emoji Button
                            IconButton(
                              icon: Icon(
                                controller.showEmoji.value
                                    ? Icons.keyboard
                                    : Icons.emoji_emotions_outlined,
                              ),
                              onPressed: () {
                                // Toggle between emoji & keyboard
                                if (controller.showEmoji.value) {
                                  controller.showEmoji.value = false;
                                  FocusScope.of(context).requestFocus(
                                      controller.focusNode); // show keyboard
                                } else {
                                  controller.showEmoji.value = true;
                                  FocusScope.of(context).unfocus(); // hide keyboard
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
                                ),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.send_rounded),
                              onPressed: controller.sendMessage,
                            ),
                          ],
                        ),
                      ),

                      // Emoji Picker (shows only when toggled)
                      if (controller.showEmoji.value)
                        SizedBox(
                          height: 300, // adjust as needed
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              controller.textCtrl.text +=
                                  emoji.emoji; // append emoji
                              controller.onTyping(controller.textCtrl.text);
                            },
                            config: Config(
                              // columns: 7,
                              // emojiSizeMax: 28,
                              // verticalSpacing: 0,
                              // horizontalSpacing: 0,
                              // gridPadding: EdgeInsets.zero,
                              // bgColor: scheme.background,
                              // indicatorColor: scheme.primary,
                              // enableSkinTones: true,
                              // recentTabBehavior: RecentTabBehavior.RECENT,
                              // recentsLimit: 28,
                              // noRecents: const Text('No Recents'),
                              // tabIndicatorAnimDuration: kTabScrollDuration,
                              // categoryIcons: const CategoryIcons(),
                              // buttonMode: ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
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
      ),
    );
  }
}

/// ───────── MESSAGE STATUS ICONS ─────────
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