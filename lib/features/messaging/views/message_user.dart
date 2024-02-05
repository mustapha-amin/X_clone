import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/widgets/message_list.dart';
import 'package:x_clone/features/messaging/widgets/message_textfield.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

import '../../auth/controller/user_data_controller.dart';
import '../repository/message_repository.dart';

class MessageUser extends ConsumerStatefulWidget {
  final XUser xUser;
  const MessageUser({required this.xUser, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageUserState();
}

class _MessageUserState extends ConsumerState<MessageUser> {
  final TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.position.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.bounceIn,
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
      body: ref.watch(fetchMessagesProvider(widget.xUser.uid!)).when(
            data: (messages) {
              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? Text(
                            "Start chat",
                            style: kTextStyle(20, ref),
                          ).centralize()
                        : MessageList(
                            messages: messages,
                            scrollController: scrollController,
                          ),
                  ),
                  MessageTextField(
                    ref: ref,
                    textEditingController: textEditingController,
                    xUser: widget.xUser,
                    scrollController: scrollController,
                    onSuccess: () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                      ref.watch(currentUserProvider).when(
                            data: (user) => !user!.conversationList!
                                    .contains(widget.xUser.uid)
                                ? ref
                                    .read(messageRepoProvider)
                                    .addToConversationList(widget.xUser.uid)
                                : null,
                            error: (_, __) => null,
                            loading: () => null,
                          );
                    },
                  )
                ],
              );
            },
            error: (_, __) => Text(
              "Error loading messages",
              style: kTextStyle(16, ref),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
