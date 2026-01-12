import 'package:flutter/material.dart';

class FeedTabButton extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FeedTabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<FeedTabButton> createState() => _FeedTabButtonState();
}

class _FeedTabButtonState extends State<FeedTabButton> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? scheme.onSurface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.selected
                    ? scheme.surface
                    : scheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
