import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_drawer_tiles.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

class XDrawer extends ConsumerWidget {
  const XDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider);
    ValueNotifier<bool> isExpanded = ValueNotifier(false);
    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(),
      width: context.screenWidth * .85,
      key: ref.watch(scaffoldKeyProvider),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            child: Text(user!.displayName![0]),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.more_vert_rounded,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                      VerticalSpacing(size: 15),
                      Text(
                        user.displayName!,
                        style: kTextStyle(
                          18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                DrawerTile(
                  title: "Profile",
                  iconData: Icons.person_2_outlined,
                  onTap: () {},
                ),
                DrawerTile.withX(
                  title: "Premium",
                  onTap: () {},
                ),
                DrawerTile(
                  title: "Bookmarks",
                  iconData: Icons.bookmark_outline,
                  onTap: () {},
                ),
                DrawerTile(
                  title: "Lists",
                  iconData: Icons.list_alt_outlined,
                  onTap: () {},
                ),
                DrawerTile(
                  title: "Spaces",
                  iconData: Icons.mic,
                  onTap: () {},
                ),
                DrawerTile(
                  title: "Monetization",
                  iconData: Icons.money_outlined,
                  onTap: () {},
                ),
                VerticalSpacing(size: 20),
                Divider(
                  height: isExpanded.value ? 3 : 0,
                ),
                ExpansionTile(
                  onExpansionChanged: (_) {
                    isExpanded.value = !isExpanded.value;
                  },
                  title: const Text("Proffesional tools"),
                  children: [
                    DrawerTile(
                      iconData: FeatherIcons.arrowUpRight,
                      title: "Ads",
                      titleSize: 14,
                      onTap: () {},
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Settings and support"),
                  children: [
                    DrawerTile(
                      iconData: FeatherIcons.settings,
                      title: "Settings and privacy",
                      titleSize: 14,
                      onTap: () {},
                    ),
                    DrawerTile(
                      iconData: FeatherIcons.helpCircle,
                      title: "Help Center",
                      titleSize: 14,
                      onTap: () {},
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.dark_mode).padX(10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
