import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:uuid/uuid.dart';
import '../../../theme/theme.dart';
import '../../../utils/utils.dart';

class PostButton extends ConsumerWidget {
  const PostButton(
      {super.key,
      required this.postTextEditingController,
      required this.images,
      required this.callback});

  final TextEditingController postTextEditingController;
  final ValueNotifier<List<File>> images;
  final VoidCallback callback;

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
          onTap: switch (postTextEditingController.text.isNotEmpty ||
              images.value.isNotEmpty) {
            true => () async => {
                  await ref.read(postNotifierProvider.notifier).createPost(
                        context,
                        PostModel(
                          uid: ref.watch(userProvider)!.uid,
                          postID: const Uuid().v4(),
                          text: postTextEditingController.text,
                          imagesUrl: images.value.isEmpty
                              ? []
                              : images.value.map((e) => e.path).toList(),
                          comments: [],
                          likesIDs: [],
                          repostCount: 0,
                          timeCreated: DateTime.now(),
                        ),
                      ),
                      callback,
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
