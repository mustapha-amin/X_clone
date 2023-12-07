import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/models/post_model.dart';

import '../../../theme/theme.dart';
import '../../../utils/utils.dart';

class PostButton extends ConsumerWidget {
  const PostButton({
    super.key,
    required this.postTextEditingController,
    required this.images,
  });

  final TextEditingController postTextEditingController;
  final ValueNotifier<List<File>> images;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: Listenable.merge(
        [
          postTextEditingController,
          images,
        ],
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: switch (postTextEditingController.text.isNotEmpty || images.value.isNotEmpty) {
            true => () async => {
                  await ref.read(postNotifierProvider.notifier).createPost(
                        context,
                        PostModel(
                          uid: ref.watch(userProvider)!.uid,
                          postID:
                              DateTime.now().microsecondsSinceEpoch.toString(),
                          text: postTextEditingController.text,
                          imagesUrl: [],
                          comments: [],
                          likesIDs: [],
                          repostCount: 0,
                          timeCreated: DateTime.now(),
                        ),
                      ),
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () => Navigator.pop(context),
                  )
                },
            _ => null
          },
          child: Container(
            width: 65,
            height: 40,
            decoration: BoxDecoration(
              color: switch (postTextEditingController.text.isNotEmpty ||
                  images.value.isNotEmpty) {
                true => AppColors.blueColor,
                _ => Colors.grey[500],
              },
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "Post",
                style: kTextStyle(15, fontWeight: FontWeight.bold),
              ),
            ),
          ).padX(8),
        );
      },
    );
  }
}
