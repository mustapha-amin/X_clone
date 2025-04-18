import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/home/views/following/following.dart';
import 'package:x_clone/features/home/views/for%20you/for_you.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        controller: scrollController,
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
                width: 25,
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
            Following(),
          ],
        ),
      ),
    );
  }
}
