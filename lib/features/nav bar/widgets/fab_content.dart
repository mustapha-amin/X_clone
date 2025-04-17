import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:x_clone/features/nav%20bar/widgets/XFab.dart';
import 'package:x_clone/features/post/views/post_screen.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/navigation.dart';
import 'package:x_clone/utils/spacing.dart';

class FabContent extends StatelessWidget {
  const FabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
