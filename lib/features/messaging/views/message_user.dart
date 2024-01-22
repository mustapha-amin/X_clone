import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/repository/message_repository.dart';
import 'package:x_clone/features/messaging/widgets/dialog_contents.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.position.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => navigateTo(
            context,
            UserProfileScreen(
              user: widget.xUser,
            ),
          ),
          child: Row(
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
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ref.watch(fetchMessagesProvider(widget.xUser.uid!)).when(
                  data: (messages) => messages.isEmpty
                      ? Center(
                          child: Text(
                            "Start a chat",
                            style: kTextStyle(16, ref),
                          ),
                        )
                      : SizedBox(
                          height: context.screenHeight * .76,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
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
                                    alignment: message.senderID !=
                                            ref.watch(uidProvider)
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      message.timeSent!
                                                  .compareTo(DateTime.now()) ==
                                              -1
                                          ? '${message.timeSent!.formatDate} - ${message.timeSent!.formatTime}'
                                          : message.timeSent!.formatTime,
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
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
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
                    ).padX(8).padY(5),
                  ),
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
                          receiverID: widget.xUser.uid,
                          timeSent: DateTime.now(),
                        ),
                      ),
                    );

                    textEditingController.clear();
                    await Future.delayed(
                      const Duration(seconds: 1),
                      () => scrollController.position.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      ),
                    );
                    ref.watch(currentUserProvider).when(
                          data: (user) =>
                              !user!.conversationList!.contains(user.uid)
                                  ? ref
                                      .read(messageRepoProvider)
                                      .addToConversationList(widget.xUser.uid)
                                  : null,
                          error: (_, __) => null,
                          loading: () => null,
                        );
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
