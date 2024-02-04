import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/messaging/views/message_user.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/textstyle.dart';

class MessageBySearch extends ConsumerStatefulWidget {
  const MessageBySearch({super.key});

  @override
  ConsumerState<MessageBySearch> createState() => _MessageBySearchState();
}

class _MessageBySearchState extends ConsumerState<MessageBySearch> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Direct message",
          style: kTextStyle(20, ref, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search user',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 40,
                ),
              ),
              // onChanged: (query) {},
            ).padAll(5),
          ),
          Expanded(
            child: ref.watch(currentUserProvider).when(
                  data: (user) => ListView.builder(
                    itemCount: user!.following!.length,
                    itemBuilder: (context, index) {
                      return ref
                          .watch(userProviderWithID(user.following![index]))
                          .when(
                            data: (following) => ListTile(
                              onTap: () {
                                navigateTo(
                                  context,
                                  MessageUser(xUser: following),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  following!.profilePicUrl!,
                                ),
                              ),
                              title: Text(
                                following.name!,
                                style: kTextStyle(
                                  18,
                                  ref,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '@${following.username!}',
                                style: kTextStyle(
                                  15,
                                  ref,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            error: (_, __) => Text(
                              "An error occured",
                              style: kTextStyle(18, ref),
                            ),
                            loading: () => const CircularProgressIndicator(),
                          );
                    },
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      "An error occured",
                      style: kTextStyle(18, ref),
                    ),
                  ),
                  loading: () => const XLoader(),
                ),
          )
        ],
      ),
    );
  }
}
