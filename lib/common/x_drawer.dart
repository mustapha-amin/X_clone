import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_drawer_tiles.dart';
import 'package:x_clone/common/x_modal_sheet.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

import 'x_avatar.dart';

class XDrawer extends ConsumerWidget {
  const XDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    ValueNotifier<bool> isExpanded = ValueNotifier(false);
    return Container(
      color: Colors.black,
      width: context.screenWidth * .85,
      key: ref.watch(scaffoldKeyProvider),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          XAvatar(forDrawer: true),
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return const XBtmModalSheet();
                                },
                              );
                            },
                            child: Container(
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
                            ),
                          )
                        ],
                      ),
                      user.when(
                        data: (user) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.name!,
                              style:
                                  kTextStyle(22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@${user.username!}',
                              style: kTextStyle(14, color: Colors.grey),
                            ),
                            VerticalSpacing(size: 16),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "${user.following!.length} ",
                                    style: kTextStyle(12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: "Following  ",
                                        style:
                                            kTextStyle(12, color: Colors.grey),
                                      ),
                                      TextSpan(
                                        text: "${user.followers!.length} ",
                                        style: kTextStyle(12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "Followers",
                                        style:
                                            kTextStyle(12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        error: (_, __) => const Text("An error occured"),
                        loading: () => const Text("Fetching details"),
                      ),
                      VerticalSpacing(size: 15),
                    ],
                  ),
                ),
                DrawerTile(
                  title: "Profile",
                  iconData: Icons.person_2_outlined,
                  onTap: () {
                    navigateTo(
                      context,
                      UserProfileScreen(
                        user: user.value,
                      ),
                    );
                  },
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
