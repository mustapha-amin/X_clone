import 'dart:developer';
import 'dart:math' hide log;

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/auth/repository/user_data_service.dart';
import 'package:x_clone/features/home/views/for%20you/post_detail_screen.dart';
import 'package:x_clone/features/home/widgets/post_icon_buttons.dart';
import 'package:x_clone/features/home/widgets/post_images.dart';
import 'package:x_clone/features/home/widgets/post_skeleton.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/features/post/controllers/post_controller.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/notification_model.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:x_clone/features/post/repository/post_service.dart';
import 'package:x_clone/utils/enums.dart';
import 'package:x_clone/utils/utils.dart';

class PostCard extends ConsumerStatefulWidget {
  PostModel? post;
  PostCard({this.post, Key? key}) : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  int currentPage = 0;

  bool isLiked(String uid) {
    return widget.post!.likesIDs!.contains(uid);
  }

  bool isReposted(String uid) {
    return widget.post!.repostIDs!.contains(uid);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userProviderWithID(widget.post!.uid!)).when(
          data: (user) {
            return GestureDetector(
              onTap: () => navigateTo(
                  context,
                  PostDetailCard(
                    post: widget.post!,
                  )),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateTo(
                            context,
                            UserProfileScreen(
                              user: user,
                            ));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user!.profilePicUrl!),
                        radius: 18,
                      ),
                    ),
                    HorizontalSpacing(size: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: user.name!,
                              style: kTextStyle(
                                15,
                                ref,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: " @${user.username}  ",
                                  style: kTextStyle(
                                    12,
                                    ref,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: timeago.format(
                                      widget.post!.timeCreated!,
                                      locale: 'en_short'),
                                  style: kTextStyle(
                                    13,
                                    ref,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          VerticalSpacing(size: 5),
                          Text(
                            widget.post!.text!,
                            style: kTextStyle(
                              16,
                              ref,
                            ),
                          ),
                          widget.post!.imagesUrl!.isEmpty
                              ? const SizedBox()
                              : PostImages(images: widget.post!.imagesUrl!)
                                  .padY(2),
                          VerticalSpacing(size: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PostIconButton(
                                iconData: FeatherIcons.messageCircle,
                                count: widget.post!.comments!.length,
                              ),
                              PostIconButton(
                                iconData: Icons.repeat,
                                color: isReposted(ref.watch(uidProvider))
                                    ? Colors.green
                                    : Colors.grey[600],
                                count: widget.post!.repostIDs!.length,
                                callback: () {
                                  try {
                                    isReposted(ref.watch(uidProvider))
                                        ? {
                                            widget.post!.repostIDs!
                                                .remove(ref.watch(uidProvider)),
                                            ref
                                                .read(postServiceProvider)
                                                .repost(widget.post,
                                                    unRepost: true)
                                          }
                                        : {
                                            widget.post!.repostIDs!
                                                .add(ref.watch(uidProvider)),
                                            ref
                                                .read(postServiceProvider)
                                                .repost(widget.post!.copyWith(
                                                  isRetweet: true,
                                                  repostIDs:
                                                      widget.post!.repostIDs,
                                                  primaryPostID:
                                                      widget.post!.postID,
                                                ))
                                          };
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                },
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
                                          // ref
                                          //     .read(notificationsStreamProvider)
                                          //     .when(
                                          //       data: (notifications) => ref.read(
                                          //           deleteNotificationProvider([
                                          //         widget.post!.uid!,
                                          //         ref.watch(uidProvider),
                                          //         widget.post!.postID!
                                          //       ])),
                                          //       error: (_, __) => null,
                                          //       loading: () => null,
                                          //     )
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
                                iconData: FeatherIcons.barChart2,
                                count: Random().nextInt(300) + 100,
                              ),
                              PostIconButton(
                                iconData: !ref
                                        .watch(currentUserProvider)
                                        .value!
                                        .bookmarkedPosts!
                                        .contains(widget.post!.postID)
                                    ? Icons.bookmark_outline
                                    : Icons.bookmark,
                                color: ref
                                        .watch(currentUserProvider)
                                        .value!
                                        .bookmarkedPosts!
                                        .contains(widget.post!.postID)
                                    ? Colors.blue
                                    : Colors.grey[600],
                                callback: () {
                                  ref.read(userDataServiceProvider).bookmark(
                                      ref.watch(currentUserProvider).value!.uid,
                                      widget.post!.postID,
                                      ref
                                          .watch(currentUserProvider)
                                          .value!
                                          .bookmarkedPosts!
                                          .contains(widget.post!.postID));
                                },
                              ),
                              PostIconButton(
                                iconData: Icons.share,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (_, __) => const Text("Error"),
          loading: () => const PostSkeleton(),
        );
  }
}
