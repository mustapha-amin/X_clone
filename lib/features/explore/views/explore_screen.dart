import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
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
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: context.screenWidth * .2,
          leading: XAvatar(),
          titleSpacing: 0,
          title: SearchBar(
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
              kTextStyle(13, color: Colors.grey[500]),
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
        )
      ],
    );
  }
}
