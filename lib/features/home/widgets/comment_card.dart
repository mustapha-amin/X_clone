import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/notification/controller/notification_controller.dart';
import 'package:x_clone/models/post_model.dart';

import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/utils.dart';
import '../../user_profile/views/user_profile_screen.dart';

class CommentCard extends ConsumerStatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.user,
    required this.post,
  });

  final CommentModel comment;
  final XUser user;
  final PostModel post;

  @override
  ConsumerState<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  navigateTo(
                      context,
                      UserProfileScreen(
                        user: widget.user,
                      ));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.user.profilePicUrl!,
                  ),
                ),
              ),
              HorizontalSpacing(size: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            navigateTo(
                                context,
                                UserProfileScreen(
                                  user: widget.user,
                                ));
                          },
                          child: Text(
                            widget.user.name!,
                            style: kTextStyle(18, ref),
                          ),
                        ),
                        Text(
                          "  @${widget.user.username}",
                          style: kTextStyle(14, ref, color: Colors.grey),
                        )
                      ],
                    ),
                    Text(widget.comment.text!),
                    VerticalSpacing(size: 10),
                    widget.comment.imagesUrls!.isEmpty
                        ? const SizedBox()
                        : const SizedBox(),
                    VerticalSpacing(size: 10),
                  ],
                ),
              )
            ],
          ),
        ),
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            size: 15,
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Delete"),
                onTap: () {},
              )
            ];
          },
        )
      ],
    );
  }
}
