import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/utils.dart';

class TweetScreen extends ConsumerStatefulWidget {
  const TweetScreen({super.key});

  @override
  ConsumerState<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends ConsumerState<TweetScreen> {
  TextEditingController postTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            width: 65,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "Post",
                style: kTextStyle(15, fontWeight: FontWeight.bold),
              ),
            ),
          ).padX(8),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    XAvatar(),
                    SizedBox(
                      width: context.screenWidth * .7,
                      child: TextField(
                        controller: postTextEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: kTextStyle(20, color: Colors.grey),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: context.screenHeight * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[800]!,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        height: context.screenWidth * .27,
                        width: context.screenWidth * .27,
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 37,
                          color: AppColors.blueColor,
                        ),
                      ).padX(8),
                    ],
                  ).padY(8),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(width: 0.3, color: Colors.white),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.public,
                        color: AppColors.blueColor,
                        size: 16,
                      ),
                      HorizontalSpacing(size: 10),
                      Text(
                        "Everyone can reply",
                        style: kTextStyle(13, color: AppColors.blueColor),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: AppColors.blueColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.gif_box_outlined,
                        color: AppColors.blueColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.checklist_rounded,
                        color: AppColors.blueColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.blueColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.circle_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
