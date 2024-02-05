import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/auth/repository/user_data_service.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/views/message_user.dart';
import 'package:x_clone/models/message_model.dart';
import 'package:x_clone/utils/utils.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          titleSpacing: 0,
          leadingWidth: context.screenWidth * .2,
          leading: XAvatar(),
          title: SearchBar(
            elevation: const MaterialStatePropertyAll(0),
            controller: searchController,
            constraints: BoxConstraints(
              minHeight: context.screenHeight * .065,
              minWidth: context.screenWidth * .8,
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey[900]!,
                ),
              ),
            ),
            hintText: "Search Direct Messages",
            hintStyle: MaterialStatePropertyAll(
              kTextStyle(13, ref, color: Colors.grey[500]),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FeatherIcons.settings,
                size: 20,
              ),
            )
          ],
        ),
        ref.watch(currentUserProvider).when(
              data: (user) => user!.conversationList!.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Text("Start a conversation"),
                      ),
                    )
                  : SliverList.builder(
                      itemCount: user.conversationList!.length,
                      itemBuilder: (context, index) {
                        String id = user.conversationList![index];
                        return ref.watch(xUserStreamProvider(id)).when(
                              data: (user) {
                                return ListTile(
                                  onTap: () => navigateTo(
                                    context,
                                    MessageUser(xUser: user),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user!.profilePicUrl!),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.name!,
                                        style: kTextStyle(
                                          15,
                                          ref,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ref
                                          .watch(
                                              fetchMessagesProvider(user.uid!))
                                          .when(
                                            data: (messages) => messages.isEmpty
                                                ? const SizedBox()
                                                : Text(
                                                    messages.last.timeSent!
                                                                .compareTo(
                                                                    DateTime
                                                                        .now()) ==
                                                            -1
                                                        ? messages[index]
                                                            .timeSent!
                                                            .formatDate
                                                        : messages[index]
                                                            .timeSent!
                                                            .formatTime,
                                                    style: kTextStyle(12, ref,
                                                        color:
                                                            Colors.grey[500])),
                                            error: (_, __) => const Text(
                                                "Error fetching time"),
                                            loading: () =>
                                                const Text("Loading..."),
                                          ),
                                    ],
                                  ),
                                  subtitle: ref
                                      .watch(fetchMessagesProvider(user.uid!))
                                      .when(
                                        data: (messages) => messages.isEmpty
                                            ? const SizedBox()
                                            : Text(
                                                messages.last.content!.length <
                                                        40
                                                    ? messages.last.content!
                                                    : '${messages.last.content!.substring(0, 40)}...',
                                              ),
                                        error: (_, __) => const Text(
                                            "Error fetching latest messages"),
                                        loading: () => const Text("Loading..."),
                                      ),
                                );
                              },
                              error: (_, __) => const Text("An error occured"),
                              loading: () => const XLoader(),
                            );
                      },
                    ),
              error: (_, __) => const SliverToBoxAdapter(
                child: Center(
                  child: Text("An error occured"),
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: XLoader(),
              ),
            ),
      ],
    );
  }
}
