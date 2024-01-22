import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/features/home/widgets/image_carousel.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/features/post/repository/post_service.dart';
import 'package:x_clone/theme/theme.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/image_pickers.dart';
import 'package:x_clone/utils/utils.dart';

import '../../../../core/core.dart';
import '../../../auth/repository/user_data_service.dart';
import '../../widgets/comment_card.dart';
import '../../widgets/post_icon_buttons.dart';

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

  void pickCameraImage() async {
    final image = await pickImageFromCamera();
    if (image != null) {
      pickedImages.add(image);
      setState(() {});
    }
  }

  FutureVoid pickGalleryImages(BuildContext context) async {
    final images = await pickImagesFromGallery();
    if (images!.isNotEmpty) {
      if (images.length <= 4) {
        pickedImages.addAll(images);
        setState(() {});
      } else {
        // ignore: use_build_context_synchronously
        showErrorDialog(
            context: context, message: "You can only pick 4 images or less");
      }
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
        elevation: 0,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateTo(
                        context,
                        UserProfileScreen(
                          user: widget.xUser,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.xUser!.profilePicUrl!),
                        ).padX(8),
                        Text(
                          widget.xUser!.name!,
                          style:
                              kTextStyle(23, ref, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.post!.text!,
                    style: kTextStyle(20, ref),
                  ).padAll(8),
                  widget.post!.imagesUrl!.isEmpty
                      ? const SizedBox()
                      : UserPostImageCarousel(
                          post: widget.post,
                          user: widget.xUser,
                        ),
                  Text(
                    '${widget.post!.timeCreated!.formatTime} - ${widget.post!.timeCreated!.formatDate}',
                    style: kTextStyle(15, ref, color: Colors.grey),
                  ).padX(8),
                  ref.watch(fetchPostByID(widget.post!.postID!)).when(
                        data: (post) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PostIconButton(
                                  iconData: FeatherIcons.messageCircle,
                                  count: post.comments!.length,
                                ),
                                PostIconButton(
                                  iconData: Icons.repeat,
                                  count: post.repostCount,
                                ),
                                PostIconButton(
                                  iconData: isLiked(ref.watch(uidProvider))
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  count: widget.post!.likesIDs!.length,
                                  callback: () async {
                                    isLiked(ref.watch(uidProvider))
                                        ? {
                                            widget.post!.likesIDs!
                                                .remove(ref.watch(uidProvider)),
                                            
                                          }
                                        : {
                                            widget.post!.likesIDs!
                                                .add(ref.watch(uidProvider)),
                                            ref.read(
                                              createNotificationProvider(
                                                NotificationModel(
                                                  senderID:
                                                      ref.watch(uidProvider),
                                                  recipientID: widget.post!.uid,
                                                  targetID: widget.post!.postID,
                                                  message: "liked your post",
                                                  notificationType:
                                                      NotificationType.like,
                                                ),
                                              ),
                                            ),
                                          };
                                    await ref
                                        .read(postServiceProvider)
                                        .likePost(widget.post);
                                    setState(() {});
                                  },
                                  color: isLiked(ref.watch(uidProvider))
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                PostIconButton(
                                  iconData: Icons.share,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ...post.comments!.map((comment) {
                              return ref
                                  .watch(xUserStreamProvider(comment.uid!))
                                  .when(
                                    data: (user) => CommentCard(
                                      comment: comment,
                                      user: user!,
                                      post: widget.post!,
                                    ).padY(8).padX(10),
                                    error: (_, __) =>
                                        const Text("Error fetching comments"),
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                  );
                            })
                          ],
                        ),
                        error: (_, __) => const Center(
                          child: Text("Error loading comments"),
                        ),
                        loading: () => Center(
                          child: const CircularProgressIndicator().padAll(7),
                        ),
                      ),
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
                                ? pickGalleryImages(context)
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
                                ? pickCameraImage()
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
                    ValueListenableBuilder(
                      valueListenable: commentController,
                      builder: (context, value, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueColor,
                            disabledBackgroundColor: Colors.grey,
                          ),
                          onPressed: value.text.isEmpty
                              ? null
                              : () async {
                                  String commentID = const Uuid().v4();
                                  ref.read(postServiceProvider).commentOnPost(
                                        CommentModel(
                                          uid: ref.watch(uidProvider),
                                          commentID: commentID,
                                          text: commentController.text,
                                          imagesUrls: pickedImages
                                              .map((e) => e.path)
                                              .toList(),
                                        ),
                                        widget.post,
                                      );
                                  ref.read(
                                    createNotificationProvider(
                                      NotificationModel(
                                        senderID: ref.watch(uidProvider),
                                        recipientID: widget.post!.uid,
                                        targetID:
                                            "${widget.post!.postID}-$commentID",
                                        message: "commented on your post",
                                        notificationType:
                                            NotificationType.comment,
                                      ),
                                    ),
                                  );
                                  commentController.clear();
                                  setState(() {
                                    pickedImages.clear();
                                  });
                                  ref.invalidate(
                                    fetchPostByID(
                                      widget.post!.postID!,
                                    ),
                                  );
                                },
                          child: Text(
                            "Reply",
                            style: kTextStyle(15, ref, color: Colors.white),
                          ),
                        ).padX(5);
                      },
                    ),
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
