import 'package:faithconnect/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) displayStringForItem;
  final void Function(T?) onChanged;
  final IconData icon;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.displayStringForItem,
    required this.onChanged,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = Get.isDarkMode;

    final appColors = theme.extension<AppColors>();

    final primary = scheme.primary;
    final fillColor = scheme.surfaceVariant;
    final dropdownColor = scheme.surface;

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: dropdownColor,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: primary,
        size: 28,
      ),
      hint: Text(
        hint,
        style: TextStyle(
          color: scheme.onSurface.withOpacity(0.6),
        ),
      ),
      style: TextStyle(
        color: scheme.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: scheme.error,
            width: 2,
          ),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayStringForItem(item),
                style: TextStyle(color: scheme.onSurface),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator:
          validator ?? (v) => v == null ? 'Please select an option' : null,
    );
  }
}
