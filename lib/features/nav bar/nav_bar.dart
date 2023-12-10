import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_drawer.dart';
import 'package:x_clone/features/explore/views/explore_screen.dart';
import 'package:x_clone/features/home/home.dart';
import 'package:x_clone/features/messaging/views/message_screen.dart';
import 'package:x_clone/features/nav%20bar/widgets/XFab.dart';
import 'package:x_clone/features/post/views/post_screen.dart';
import 'package:x_clone/services/services.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/spacing.dart';
import '../../utils/navigation.dart';
import '../auth/controller/auth_controller.dart';
import '../notification/views/notification_screen.dart';

final navbarProvider = StateProvider<int>((ref) {
  return 0;
});

final expandedProvider = StateProvider<bool>((ref) {
  return false;
});

class XBottomNavBar extends ConsumerStatefulWidget {
  const XBottomNavBar({super.key});

  @override
  ConsumerState<XBottomNavBar> createState() => _XBottomNavBarState();
}

class _XBottomNavBarState extends ConsumerState<XBottomNavBar> {
  List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const NotificationScreen(),
    const MessageScreen(),
  ];

  void toggleExpanded() {
    ref.read(expandedProvider.notifier).state = !ref.watch(expandedProvider);
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(navbarProvider);
    bool isExpanded = ref.watch(expandedProvider);
    bool isDark = ref.watch(themeNotifierProvider);
    return SafeArea(
      child: Scaffold(
        drawer: const XDrawer(),
        body: GestureDetector(
          onTap: () => isExpanded ? toggleExpanded() : null,
          child: Stack(
            children: [
              IndexedStack(
                index: index,
                children: screens,
              ),
              isExpanded
                  ? Container(
                      color: Colors.black.withOpacity(0.8),
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: switch ((isDark, isExpanded)) {
              (true, _) => Colors.black.withOpacity(0.8),
              (false, false) => Colors.white,
              _ => Colors.black.withOpacity(0.8),
            },
            currentIndex: index,
            onTap: (index) {
              ref.read(navbarProvider.notifier).state = index;
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon:
                    Icon(index == 0 ? Icons.home_filled : Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FeatherIcons.search,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  index == 2 ? Icons.notifications : Icons.notifications_none,
                  size: 27,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  index == 3
                      ? Icons.local_post_office
                      : Icons.local_post_office_outlined,
                ),
                label: '',
              ),
            ],
          ),
        ),
        floatingActionButton: switch (index) {
          0 => switch (isExpanded) {
              true => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    XFab(
                      label: "Go Live",
                      onTap: () {},
                      iconData: FeatherIcons.video,
                    ),
                    VerticalSpacing(size: 10),
                    XFab(
                      label: "Spaces",
                      onTap: () {},
                      iconData: FeatherIcons.mic,
                    ),
                    VerticalSpacing(size: 10),
                    XFab(
                      label: "Photos",
                      onTap: () {},
                      iconData: Icons.photo,
                    ),
                    VerticalSpacing(size: 10),
                    XFab(
                      isMain: true,
                      bgColor: AppColors.blueColor,
                      fgColor: Colors.white,
                      label: "Post",
                      onTap: () => navigateTo(context, const PostScreen()),
                      iconData: FeatherIcons.feather,
                    ),
                  ],
                ),
              _ => XFab(
                  isMain: true,
                  bgColor: AppColors.blueColor,
                  fgColor: Colors.white,
                  onTap: toggleExpanded,
                  iconData: Icons.add,
                ),
            },
          3 => Stack(
              alignment: Alignment.center,
              children: [
                XFab(
                  isMain: true,
                  bgColor: AppColors.blueColor,
                  fgColor: Colors.white,
                  onTap: () {},
                  iconData: Icons.local_post_office_outlined,
                ),
                Positioned(
                  right: 10,
                  bottom: 15,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blueColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}
