import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/common/x_drawer.dart';
import 'package:x_clone/features/auth/repository/user_data_service.dart';
import 'package:x_clone/features/explore/views/explore_screen.dart';
import 'package:x_clone/features/home/home.dart';
import 'package:x_clone/features/messaging/views/message_screen.dart';
import 'package:x_clone/features/nav%20bar/widgets/XFab.dart';
import 'package:x_clone/features/post/views/post_screen.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/spacing.dart';
import '../../core/core.dart';
import '../../utils/navigation.dart';
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
  final List<Widget> screens = const [
    HomeScreen(),
    ExploreScreen(),
    NotificationScreen(),
    MessageScreen(),
  ];

  void toggleExpanded() {
    ref.read(expandedProvider.notifier).state = !ref.watch(expandedProvider);
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(navbarProvider);
    bool isExpanded = ref.watch(expandedProvider);
    bool isDark = ref.watch(themeNotifierProvider);
    final userDetail = ref.watch(xUserDetailExistsProvider);
    return userDetail.when(
      data: (userExists) => switch (userExists) {
        true => SafeArea(
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
                  selectedItemColor: isDark ? Colors.white : Colors.black,
                  unselectedItemColor: isDark ? Colors.white : Colors.black,
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
                      icon: Icon(
                          index == 0 ? Icons.home_filled : Icons.home_outlined),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(
                        FeatherIcons.search,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Icon(
                            index == 2
                                ? Icons.notifications
                                : Icons.notifications_none,
                            size: 27,
                          ),
                          ref
                              .watch(
                                  xUserStreamProvider(ref.watch(uidProvider)))
                              .when(
                                data: (user) => user!.notificationCount! > 0
                                    ? Badge.count(
                                        count: user.notificationCount!,
                                        backgroundColor: AppColors.blueColor,
                                        textColor: Colors.white,
                                      )
                                    : const SizedBox(),
                                error: (_, __) => const SizedBox(),
                                loading: () => const SizedBox(),
                              )
                        ],
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
                            onTap: () =>
                                navigateTo(context, const PostScreen()),
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
          ),
        _ => const UserDetails()
      },
      error: (_, __) => const ErrorScreen(),
      loading: () => const XLoader(),
    );
  }
}
