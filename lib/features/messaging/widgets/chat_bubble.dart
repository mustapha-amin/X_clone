import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/utils/utils.dart';
import '../../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final Message message;
  final TextStyle messageTextStyle;
  const ChatBubble({
    required this.isSender,
    required this.message,
    required this.messageTextStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          constraints: BoxConstraints(
            maxWidth: 60.w,
          ),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue : Colors.grey[700],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomRight: isSender ? Radius.zero : const Radius.circular(15),
              bottomLeft: isSender ? const Radius.circular(15) : Radius.zero,
            ),
          ),
          child: Text(
            message.content!,
            style: messageTextStyle,
          ),
        ).padAll(5),
      ],
    );
  }
}
