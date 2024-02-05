import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/features/messaging/widgets/chat_bubble.dart';
import 'package:x_clone/features/messaging/widgets/dialog_contents.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/utils/extensions.dart';

import '../../../utils/textstyle.dart';

class MessageList extends ConsumerStatefulWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  const MessageList({
    required this.messages,
    required this.scrollController,
    super.key,
  });

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  bool isSender(Message message, WidgetRef ref) {
    return message.senderID == ref.watch(uidProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        DateTime dateTime = message.timeSent!;
        bool sameDateAsAbove = false;
        bool sameTimeAsBelow = false;
        if (index == 0) {
          sameDateAsAbove = false;
        } else {
          if (message.timeSent!
              .eqvYearMonthDay(widget.messages[index - 1].timeSent!)) {
            sameDateAsAbove = true;
          } else {
            sameDateAsAbove = false;
          }
        }
        if (index < widget.messages.indexOf(widget.messages.last)) {
          if (message.timeSent!.formatTime ==
              widget.messages[index + 1].timeSent!.formatTime) {
            sameTimeAsBelow = true;
          } else {
            sameTimeAsBelow = false;
          }
        }
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: [
                    DialogContent(message: message),
                  ],
                );
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!sameDateAsAbove)
                Text(
                  dateTime.when,
                  style: kTextStyle(15, ref),
                ),
              ChatBubble(
                isSender: isSender(message, ref),
                message: message,
                messageTextStyle: kTextStyle(14, ref),
              ),
              if (!sameTimeAsBelow)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dateTime.formatTime,
                      style: kTextStyle(13, ref, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
