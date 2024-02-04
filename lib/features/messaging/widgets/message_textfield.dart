import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/repository/message_repository.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';

import '../../auth/controller/user_data_controller.dart';

class MessageTextField extends ConsumerWidget {
  final WidgetRef ref;
  final XUser xUser;
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final VoidCallback onSuccess;
  const MessageTextField({
    required this.ref,
    required this.textEditingController,
    required this.xUser,
    required this.scrollController,
    required this.onSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ColoredBox(
              color: Colors.blueGrey,
              child: TextField(
                controller: textEditingController,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Write a message...",
                    hintStyle: kTextStyle(15, ref),
                    contentPadding: const EdgeInsets.all(10),
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
          ).padX(8).padY(5),
        ),
        IconButton(
          color: AppColors.blueColor,
          onPressed: () async {
            ref.read(
              sendMessageProvider(
                Message(
                  id: const Uuid().v4(),
                  content: textEditingController.text.trim(),
                  senderID: ref.watch(uidProvider),
                  receiverID: xUser.uid,
                  timeSent: DateTime.now(),
                ),
              ),
            );
            textEditingController.clear();
            onSuccess.call();
            ref.watch(currentUserProvider).when(
                  data: (user) => !user!.conversationList!.contains(user.uid)
                      ? ref
                          .read(messageRepoProvider)
                          .addToConversationList(xUser.uid)
                      : null,
                  error: (_, __) => null,
                  loading: () => null,
                );
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
