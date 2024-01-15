import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/widgets/dialog_contents.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MessageUser extends ConsumerStatefulWidget {
  final XUser xUser;
  const MessageUser({required this.xUser, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageUserState();
}

class _MessageUserState extends ConsumerState<MessageUser> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.xUser.profilePicUrl!),
            ),
            HorizontalSpacing(size: 10),
            Text(
              widget.xUser.name!,
              style: kTextStyle(20, ref, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ref.watch(fetchMessagesProvider(widget.xUser.uid!)).when(
                data: (messages) => Expanded(
                  child: messages.isEmpty
                      ? Center(
                          child: Text(
                            "Start a chat",
                            style: kTextStyle(16, ref),
                          ),
                        )
                      : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            Message message = messages[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
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
                                  child: BubbleNormal(
                                    color: message.senderID ==
                                            ref.watch(uidProvider)
                                        ? AppColors.blueColor
                                        : Colors.grey,
                                    text: message.content!,
                                    isSender: message.senderID ==
                                        ref.watch(uidProvider),
                                    textStyle: kTextStyle(15, ref),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      message.senderID != ref.watch(uidProvider)
                                          ? Alignment.topLeft
                                          : Alignment.topRight,
                                  child: Text(
                                    message.timeSent!.formatTime,
                                    style: kTextStyle(12, ref,
                                        color: Colors.grey[500]),
                                  ).padX(16),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                error: (_, __) => Text(
                  "Error loading messages",
                  style: kTextStyle(16, ref),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ColoredBox(
                    color: Colors.blueGrey,
                    child: TextField(
                      controller: textEditingController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: "Write a message...",
                          hintStyle: kTextStyle(15, ref),
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )
                          // prefix: IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.photo),
                          // ),
                          ),
                    ),
                  ),
                ).padX(8).padY(3),
              ),
              IconButton(
                color: AppColors.blueColor,
                onPressed: () {
                  ref.read(
                    sendMessageProvider(
                      Message(
                        id: const Uuid().v4(),
                        content: textEditingController.text.trim(),
                        senderID: ref.watch(uidProvider),
                        receiverID: widget.xUser.uid,
                        timeSent: DateTime.now(),
                      ),
                    ),
                  );
                  textEditingController.clear();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}
