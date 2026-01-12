import 'package:faithconnect/app/core/utils/constant.dart';
import 'package:flutter/material.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusIcon(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.SEEN:
        icon = Icons.done_all;
        color = Colors.green;
        break;
      case MessageStatus.DELIVERED:
        icon = Icons.done_all;
        color = Colors.grey;
        break;
      default:
        icon = Icons.check;
        color = Colors.grey;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(icon, size: 16, color: color, key: ValueKey(icon)),
    );
  }
}
