import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/explore/controllers/search_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/utils/utils.dart';
import '../../../core/core.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: context.screenWidth * .2,
        leading: XAvatar(),
        titleSpacing: 0,
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
          hintText: "Search X",
          hintStyle: MaterialStatePropertyAll(
            kTextStyle(13, ref, color: Colors.grey[500]),
          ),
          onChanged: (value) {
            ref.read(searchUsersProvider(searchController.text.toLowerCase()));
            setState(() {});
          },
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
      body: ref
          .watch(searchUsersProvider(searchController.text.toLowerCase()))
          .when(
            data: (users) => ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    navigateTo(
                      context,
                      UserProfileScreen(
                        user: users[index],
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        users[index].profilePicUrl!,
                      ),
                    ),
                    title: Text(
                      users[index].name!,
                      style: kTextStyle(18, ref),
                    ),
                    subtitle: Text(
                      '@${users[index].username!}',
                      style: kTextStyle(13, ref, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
            error: (_, __) => Text("An error occured"),
            loading: () => const XLoader(),
          ),
    );
  }
}
