import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeadersChatShimmer extends StatelessWidget {
  const LeadersChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? scheme.surfaceVariant.withOpacity(0.6)
        : scheme.surfaceVariant;

    final highlightColor = isDark
        ? scheme.onSurface.withOpacity(0.15)
        : scheme.onSurface.withOpacity(0.08);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: 8,
      itemBuilder: (_, i) {
        final isMe = i.isEven;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 240),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      Radius.circular(isMe ? 16 : 0),
                  bottomRight:
                      Radius.circular(isMe ? 0 : 16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 10,
                    width: isMe ? 120 : 160,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
