import 'package:faithconnect/app/modules/BottomNavForLeaders/controllers/bottom_nav_for_leaders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FloatingBottomNavForLeaders extends StatelessWidget {
  FloatingBottomNavForLeaders({super.key});

  final BottomNavForLeadersController controller = Get.put(BottomNavForLeadersController());

  final List<IconData> icons = const [
    Iconsax.home,
    Iconsax.people,
    Iconsax.play,
    Iconsax.message,
    Iconsax.notification,
  ];

  final List<IconData> selectedIcons = const [
    Iconsax.home_1,
    Iconsax.people5,
    Iconsax.play_circle5,
    Iconsax.message_25,
    Iconsax.notification_bing,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Get.isDarkMode;

    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: 72,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.14),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(icons.length, (i) {
            final bool isSelected = controller.index.value == i;

            // Center button (Reels)
            if (i == 2) {
              return GestureDetector(
                onTap: () => controller.changeIndex(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [scheme.primary, scheme.primary.withOpacity(0.85)]
                          : [scheme.surfaceVariant, scheme.surfaceVariant.withOpacity(0.92)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      // Always provide shadow (even invisible when not selected)
                      BoxShadow(
                        color: isSelected
                            ? scheme.primary.withOpacity(0.38)
                            : Colors.transparent, // ← Key fix: transparent instead of empty list
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    isSelected ? selectedIcons[i] : icons[i],
                    size: 28,
                    color: isSelected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
              );
            }

            // Normal icons
            return GestureDetector(
              onTap: () => controller.changeIndex(i),
              behavior: HitTestBehavior.translucent,
              child: AnimatedScale(
                scale: isSelected ? 1.18 : 1.0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
                child: Icon(
                  isSelected ? selectedIcons[i] : icons[i],
                  size: 26,
                  color: isSelected ? scheme.primary : scheme.onSurface.withOpacity(0.58),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}