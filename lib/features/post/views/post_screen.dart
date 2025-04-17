import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/features/post/widgets/extra_icons.dart';
import 'package:x_clone/features/post/widgets/image_carousel.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/image_pickers.dart';
import 'package:x_clone/utils/utils.dart';
import '../widgets/post_button.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  TextEditingController postTextEditingController = TextEditingController();
  List<File?> pickedImages = [];
  FocusNode postFieldFocus = FocusNode();

  void pickCameraImage() async {
    File? image = await pickImageFromCamera();
    if (image != null) {
      pickedImages.add(image);
      setState(() {});
    }
  }

  void pickGalleryImages() async {
    final images = await pickImagesFromGallery();
    if (images!.isNotEmpty) {
      pickedImages.addAll(images.toList());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(microseconds: 200),
          () => FocusScope.of(context).requestFocus(postFieldFocus));
    });
  }

  @override
  void dispose() {
    postTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Status postStatus = ref.watch(postNotifierProvider);
    return switch (postStatus) {
      Status.initial || Status.success || Status.loading => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              PostButton(
                postTextEditingController: postTextEditingController,
                images: ValueNotifier(pickedImages),
              ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.screenWidth * .7,
                              child: Column(
                                children: [
                                  TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    focusNode: postFieldFocus,
                                    controller: postTextEditingController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: "What's happening?",
                                      hintStyle: kTextStyle(20, ref,
                                          color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: kTextStyle(
                                      20,
                                      ref,
                                    ),
                                  ),
                                  switch (pickedImages.isNotEmpty) {
                                    true =>
                                      ImageCarousel(pickedImages: pickedImages),
                                    _ => const SizedBox(),
                                  }
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                          style:
                              kTextStyle(13, ref, color: AppColors.blueColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          pickGalleryImages();
                        },
                        icon: const Icon(
                          Icons.photo_outlined,
                          color: AppColors.blueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          pickCameraImage();
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.blueColor,
                        ),
                      ),
                      const ExtraIconButtons(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      _ => const XLoader(),
    };
  }
}
