import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/auth/repository/user_data_service.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/features/messaging/views/message_user.dart';
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
              data: (user) => SliverList.builder(
                itemCount: user!.conversationList!.length,
                itemBuilder: (context, index) {
                  String id = user.conversationList![index];
                  return ref.watch(xUserStreamProvider(id)).when(
                        data: (user) => ListTile(
                          onTap: () => navigateTo(
                            context,
                            MessageUser(xUser: user),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user!.profilePicUrl!),
                          ),
                          title: Text(user.name!),
                          subtitle:
                              ref.watch(fetchMessagesProvider(user.uid!)).when(
                                    data: (messages) =>
                                        Text(messages.last.content!),
                                    error: (_, __) => const Text(
                                        "Error fetching latest messages"),
                                    loading: () => const Text("Loading..."),
                                  ),
                        ),
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
