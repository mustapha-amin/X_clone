import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/views/for_you.dart';
import 'package:x_clone/services/services.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void openDrawer(WidgetRef ref) {
    ref.watch(scaffoldKeyProvider).currentState!.isDrawerOpen
        ? ref.read(scaffoldKeyProvider).currentState!.closeEndDrawer()
        : ref.read(scaffoldKeyProvider).currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              leadingWidth: context.screenWidth * .2,
              leading: XAvatar(),
              title: SvgPicture.asset(
                ImagesPaths.x_icon,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                width: 30,
              ),
              centerTitle: true,
              bottom: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(
                    child: Text(
                      "For you",
                      style: kTextStyle(
                        16,
                        ref,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Following",
                      style: kTextStyle(
                        16,
                        ref,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: const TabBarView(
          children: [
            ForYou(),
            Center(child: Text("Hi")),
          ],
        ),
      ),
    );
  }
}
