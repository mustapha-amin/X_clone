import 'dart:developer';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/auth.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/common/x_drawer.dart';
import 'package:x_clone/features/explore/views/explore_screen.dart';
import 'package:x_clone/features/grok/view/grokscreen.dart';
import 'package:x_clone/features/home/home.dart';
import 'package:x_clone/features/messaging/views/message_screen.dart';
import 'package:x_clone/features/nav%20bar/widgets/XFab.dart';
import 'package:x_clone/features/nav%20bar/widgets/add_message_icon.dart';
import 'package:x_clone/features/nav%20bar/widgets/fab_content.dart';
import 'package:x_clone/features/nav%20bar/widgets/grok_icon.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/theme/pallete.dart';
import '../../core/core.dart';
import '../notification/views/notification_screen.dart';

final navbarProvider = StateProvider<int>((ref) {
  return 0;
});

final fabIsExpandedProvider = StateProvider<bool>((ref) {
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
    GrokScreen(),
    NotificationScreen(),
    MessageScreen(),
  ];

  void toggleExpanded() {
    ref.read(fabIsExpandedProvider.notifier).state =
        !ref.watch(fabIsExpandedProvider);
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(navbarProvider);
    bool isExpanded = ref.watch(fabIsExpandedProvider);
    bool isDark = ref.watch(themeNotifierProvider);
    final userDetail = ref.watch(xUserDetailExistsProvider);
    return userDetail.when(
      data: (userExists) => switch (userExists) {
        true => SafeArea(
            child: Scaffold(
              key: scaffoldKey,
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
                    if (ref.watch(navbarProvider) == 3) {
                      ref.watch(notificationsStreamProvider).when(
                            data: (notifications) {
                              List<NotificationModel> unreadNotifications =
                                  notifications!
                                      .where((notification) =>
                                          notification.isRead! == false)
                                      .toList();
                              // log(unreadNotifications.length.toString());
                              if (unreadNotifications.isNotEmpty) {
                                for (final notification
                                    in unreadNotifications) {
                                  log(notification.id!);
                                  ref.read(readNotificationProvider(
                                      notification.id!));
                                }
                              }
                            },
                            error: (_, __) => null,
                            loading: () => null,
                          );
                    }
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
                        weight: 20,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: GrokIcon(selected: index == 2),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Icon(
                            index == 3
                                ? Icons.notifications
                                : Icons.notifications_none,
                            size: 27,
                          ),
                          ref.watch(notificationsStreamProvider).when(
                                data: (notifications) {
                                  List<NotificationModel> unreadNotifications =
                                      notifications!
                                          .where((notification) =>
                                              !notification.isRead!)
                                          .toList();
                                  return unreadNotifications.isNotEmpty
                                      ? Badge.count(
                                          count: unreadNotifications.length,
                                          backgroundColor: AppColors.blueColor,
                                          textColor: Colors.white,
                                        )
                                      : const SizedBox();
                                },
                                error: (_, __) => const SizedBox(),
                                loading: () => const SizedBox(),
                              )
                        ],
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        index == 4
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
                    true => const FabContent(),
                    _ => XFab(
                        isMain: true,
                        bgColor: AppColors.blueColor,
                        fgColor: Colors.white,
                        onTap: toggleExpanded,
                        iconData: Icons.add,
                      ),
                  },
                4 => const AddMessageIcon(),
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
