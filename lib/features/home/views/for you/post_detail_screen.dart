import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/theme/theme.dart';
import 'package:x_clone/utils/utils.dart';

import '../../../../core/core.dart';

class PostDetailsScreen extends ConsumerStatefulWidget {
  PostModel? post;
  XUser? xUser;
  PostDetailsScreen({this.post, this.xUser, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsScreenState();
}

class _PostDetailsScreenState extends ConsumerState<PostDetailsScreen> {
  TextEditingController commentController = TextEditingController();
  int currentPage = 0;
  List<File> pickedImages = [];

  bool isLiked(String uid) {
    return widget.post!.likesIDs!.contains(uid);
  }

  FutureVoid pickImageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pickedImages.add(File(image.path));
      setState(() {});
    }
  }

  FutureVoid pickImagesFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    final images = await imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      images.forEach((image) {
        pickedImages.length < 4 ? pickedImages.add(File(image.path)) : null;
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post",
          style: kTextStyle(25, ref, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(
                    post: widget.post,
                    isDetailScreen: true,
                  )
                ],
              ),
            ).padX(4),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: pickedImages.isEmpty
                  ? context.screenHeight * .17
                  : context.screenHeight * .38,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                switch (pickedImages.isNotEmpty) {
                  true => Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: [
                              ...pickedImages.map(
                                (e) => Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.file(
                                      e,
                                      fit: BoxFit.cover,
                                      width: context.screenWidth * .5,
                                      height: context.screenHeight * .2,
                                    ).padX(5),
                                    IconButton.filledTonal(
                                      onPressed: () {
                                        setState(() {
                                          pickedImages.remove(e);
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  _ => const SizedBox(),
                },
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Post your reply",
                    hintStyle: kTextStyle(15, ref, color: Colors.grey),
                  ),
                ).padX(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          color: AppColors.blueColor,
                          onPressed: () {
                            pickedImages.length < 4
                                ? pickImagesFromGallery()
                                : showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          "You can't select more than 4 images",
                                          style: kTextStyle(15, ref),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                          },
                          icon: const Icon(Icons.photo_outlined),
                        ),
                        IconButton(
                          color: AppColors.blueColor,
                          onPressed: () {
                            pickedImages.length < 4
                                ? pickImageFromCamera()
                                : showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          "You can't select more than 4 images",
                                          style: kTextStyle(15, ref),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueColor,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Reply",
                        style: kTextStyle(15, ref, color: Colors.white),
                      ),
                    ).padX(5)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
