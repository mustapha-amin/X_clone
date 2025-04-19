import 'dart:io';
import 'dart:math';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/auth/repository/user_data_service.dart';
import 'package:x_clone/features/home/widgets/comment_card.dart';
import 'package:x_clone/features/home/widgets/post_icon_buttons.dart';
import 'package:x_clone/features/home/widgets/post_images.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/comment_model.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:x_clone/features/post/repository/post_service.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/image_pickers.dart';
import 'package:x_clone/utils/utils.dart';

class PostDetailCard extends ConsumerStatefulWidget {
  final PostModel post;
  const PostDetailCard({required this.post, Key? key}) : super(key: key);

  @override
  ConsumerState<PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends ConsumerState<PostDetailCard> {
  TextEditingController commentController = TextEditingController();
  int currentPage = 0;
  List<File> pickedImages = [];

  bool isLiked(String uid) => widget.post.likesIDs!.contains(uid);

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
    final uid = ref.watch(uidProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post",
          style: kTextStyle(18, ref),
        ),
      ),
      body: ref.watch(userProviderWithID(widget.post.uid!)).when(
            data: (user) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateTo(
                                    context, UserProfileScreen(user: user)),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user!.profilePicUrl!),
                                  radius: 20,
                                ),
                              ),
                              HorizontalSpacing(size: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name!,
                                    style: kTextStyle(16, ref,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '@${user.username}',
                                    style:
                                        kTextStyle(14, ref, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          VerticalSpacing(size: 12),
                          Text(
                            widget.post.text!,
                            style: kTextStyle(18, ref),
                          ),
                          VerticalSpacing(size: 10),
                          if (widget.post.imagesUrl!.isNotEmpty)
                            PostImages(images: widget.post.imagesUrl!).padY(8),
                          VerticalSpacing(size: 10),
                          Text(
                            DateFormat('h:mm a · MMM d, yyyy')
                                .format(widget.post.timeCreated!),
                            style: kTextStyle(13, ref, color: Colors.grey[600]),
                          ),
                          VerticalSpacing(size: 10),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PostIconButton(
                                iconData: FeatherIcons.messageCircle,
                              ),
                              PostIconButton(
                                iconData: Icons.repeat,
                                count: widget.post.repostIDs!.length,
                              ),
                              PostIconButton(
                                iconData: isLiked(uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                count: widget.post.likesIDs!.length,
                                color: isLiked(uid) ? Colors.red : Colors.grey,
                                callback: () async {
                                  if (isLiked(uid)) {
                                    widget.post.likesIDs!.remove(uid);
                                  } else {
                                    widget.post.likesIDs!.add(uid);
                                    ref.read(createNotificationProvider(
                                      NotificationModel(
                                        senderID: uid,
                                        recipientID: widget.post.uid,
                                        targetID: widget.post.postID,
                                        message: "liked your post",
                                        notificationType: NotificationType.like,
                                      ),
                                    ));
                                  }
                                  await ref
                                      .read(postServiceProvider)
                                      .likePost(widget.post);
                                  setState(() {});
                                },
                              ),
                              PostIconButton(
                                iconData: FeatherIcons.barChart2,
                                count: Random().nextInt(300) + 100,
                              ),
                              PostIconButton(
                                iconData: ref
                                        .watch(currentUserProvider)
                                        .value!
                                        .bookmarkedPosts!
                                        .contains(widget.post.postID)
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: ref
                                        .watch(currentUserProvider)
                                        .value!
                                        .bookmarkedPosts!
                                        .contains(widget.post.postID)
                                    ? Colors.blue
                                    : Colors.grey[600],
                                callback: () {
                                  ref.read(userDataServiceProvider).bookmark(
                                        uid,
                                        widget.post.postID,
                                        ref
                                            .watch(currentUserProvider)
                                            .value!
                                            .bookmarkedPosts!
                                            .contains(widget.post.postID),
                                      );
                                },
                              ),
                              PostIconButton(
                                iconData: Icons.share,
                              ),
                            ],
                          ),
                          VerticalSpacing(size: 20),
                          ref
                              .watch(fetchCommentsProvider(widget.post.postID!))
                              .when(
                                data: (comments) {
                                  return Column(
                                    children: [
                                      ...comments.map((comment) {
                                        return ref
                                            .watch(xUserStreamProvider(
                                                comment.uid!))
                                            .when(
                                              data: (user) => CommentCard(
                                                comment: comment,
                                                user: user!,
                                                post: widget.post,
                                              ).padY(8).padX(10),
                                              error: (_, __) => const Text(
                                                  "Error fetching comments"),
                                              loading: () =>
                                                  const CircularProgressIndicator(),
                                            );
                                      })
                                    ],
                                  );
                                },
                                error: (_, __) =>
                                    const Text("Error loading comments"),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: pickedImages.isEmpty
                            ? 100
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
                                                height:
                                                    context.screenHeight * .2,
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
                              hintStyle:
                                  kTextStyle(15, ref, color: Colors.grey),
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
                                                        Navigator.of(context)
                                                            .pop();
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
                                                        Navigator.of(context)
                                                            .pop();
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
                                            String commentID =
                                                const Uuid().v4();
                                            ref
                                                .read(postServiceProvider)
                                                .commentOnPost(
                                                  CommentModel(
                                                    uid: ref.watch(uidProvider),
                                                    commentID: commentID,
                                                    text:
                                                        commentController.text,
                                                    imagesUrls: pickedImages
                                                        .map((e) => e.path)
                                                        .toList(),
                                                  ),
                                                  widget.post,
                                                );
                                            ref.read(
                                              createNotificationProvider(
                                                NotificationModel(
                                                  senderID:
                                                      ref.watch(uidProvider),
                                                  recipientID: widget.post!.uid,
                                                  targetID:
                                                      "${widget.post!.postID}-$commentID",
                                                  message:
                                                      "commented on your post",
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
                                      style: kTextStyle(15, ref,
                                          color: Colors.white),
                                    ),
                                  ).padX(5);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            error: (_, __) => const Center(child: Text("Error loading post")),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
