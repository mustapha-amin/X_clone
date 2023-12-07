import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/features/post/widgets/extra_icons.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/post_button.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  TextEditingController postTextEditingController = TextEditingController();
  List<File> pickedImages = [];

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
        pickedImages.add(File(image.path));
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(postNotifierProvider);
    return isLoading
        ? const XLoader()
        : Scaffold(
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
                                      controller: postTextEditingController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "What's happening?",
                                        hintStyle:
                                            kTextStyle(20, color: Colors.grey),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      style: kTextStyle(
                                        20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    switch (pickedImages.isNotEmpty) {
                                      true => CarouselSlider(
                                          items: [
                                            ...pickedImages.map(
                                              (image) => Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                    height:
                                                        context.screenWidth *
                                                            .7,
                                                  ),
                                                  IconButton.filledTonal(
                                                    onPressed: () {
                                                      setState(() {
                                                        pickedImages
                                                            .remove(image);
                                                      });
                                                    },
                                                    icon:
                                                        const Icon(Icons.clear),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          options: CarouselOptions(
                                            viewportFraction: 0.7,
                                            height: context.screenWidth * .7,
                                            enableInfiniteScroll: false,
                                            enlargeCenterPage: true,
                                          ),
                                        ),
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
                          horizontal:
                              BorderSide(width: 0.3, color: Colors.white),
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
                          onPressed: () async {
                            await pickImagesFromGallery();
                          },
                          icon: const Icon(
                            Icons.photo_outlined,
                            color: AppColors.blueColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await pickImageFromCamera();
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
          );
  }
}
