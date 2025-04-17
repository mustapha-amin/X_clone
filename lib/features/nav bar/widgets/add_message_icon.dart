import 'package:flutter/material.dart';
import 'package:x_clone/features/messaging/views/message_by_search.dart';
import 'package:x_clone/features/nav%20bar/widgets/XFab.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/navigation.dart';

class AddMessageIcon extends StatelessWidget {
  const AddMessageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        XFab(
          isMain: true,
          bgColor: AppColors.blueColor,
          fgColor: Colors.white,
          onTap: () {
            navigateTo(context, const MessageBySearch());
          },
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
    );
  }
}
