import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/constants/svg_paths.dart';
import 'package:x_clone/core/core.dart';
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
    var user = ref.watch(userProvider);
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              leadingWidth: context.screenWidth * .2,
              leading: const XAvatar(),
              title: SvgPicture.asset(
                SvgPaths.x_icon,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
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
                      style: kTextStyle(16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Following",
                      style: kTextStyle(16),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: const TabBarView(
          children: [
            Center(child: Text("Hello")),
            Center(child: Text("Hi")),
          ],
        ),
      ),
    );
  }
}
