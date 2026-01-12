import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  // ───────────────────────── INFO
  static void info(String message) {
    _show(
      title: "Info",
      message: message,
      icon: Icons.info_rounded,
      type: _SnackType.info,
    );
  }

  // ───────────────────────── SUCCESS
  static void success(String message) {
    _show(
      title: "Success",
      message: message,
      icon: Icons.check_circle_rounded,
      type: _SnackType.success,
    );
  }

  // ───────────────────────── ERROR
  static void error(String message) {
    _show(
      title: "Error",
      message: message,
      icon: Icons.error_rounded,
      type: _SnackType.error,
    );
  }

  // ───────────────────────── LOADING
  static void loading(String message) {
    final context = Get.context!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: false,
      duration: const Duration(days: 1),
      backgroundColor: scheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      borderRadius: 18,
      messageText: _SnackbarBody(
        title: "Loading",
        message: message,
        leading: const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2.6),
        ),
        accentColor: scheme.primary,
      ),
    );
  }

  // ───────────────────────── CORE
  static void _show({
    required String title,
    required String message,
    required IconData icon,
    required _SnackType type,
  }) {
    final context = Get.context!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Color accentColor = switch (type) {
      _SnackType.success => Colors.green,
      _SnackType.error => scheme.error,
      _SnackType.info => scheme.primary,
    };

    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: scheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      borderRadius: 18,
      duration: const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(Get.isDarkMode ? 0.45 : 0.18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
      messageText: _SnackbarBody(
        title: title,
        message: message,
        leading: Icon(icon, size: 22, color: accentColor),
        accentColor: accentColor,
      ),
    );
  }
}

/// ───────────────────────── TYPES
enum _SnackType { success, error, info }

/// ───────────────────────── BODY
class _SnackbarBody extends StatelessWidget {
  final String title;
  final String message;
  final Widget leading;
  final Color accentColor;

  const _SnackbarBody({
    required this.title,
    required this.message,
    required this.leading,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent bar
        Container(
          width: 4,
          height: 52,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 14),

        // Icon
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: leading,
        ),
        const SizedBox(width: 14),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: scheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        // Close
        InkWell(
          onTap: Get.closeCurrentSnackbar,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.close,
              size: 18,
              color: scheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
