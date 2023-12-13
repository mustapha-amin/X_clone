import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/utils.dart';
import '../../user_profile/views/user_profile_screen.dart';

class CommentCard extends ConsumerStatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.user,
  });

  final CommentModel comment;
  final XUser user;

  @override
  ConsumerState<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    "@${widget.user.username}",
                    style: kTextStyle(14, ref, color: Colors.grey),
                  )
                ],
              ),
              Text(widget.comment.text!),
              VerticalSpacing(size: 10),
              widget.comment.imagesUrls!.isEmpty
                  ? const SizedBox()
                  : CarouselSlider(
                      items: [
                        ...widget.comment.imagesUrls!.map((e) => Image.network(
                              e,
                              fit: BoxFit.cover,
                            ).padX(5))
                      ],
                      options: CarouselOptions(
                        padEnds: false,
                        initialPage: currentPage,
                        enableInfiniteScroll: false,
                        height: context.screenHeight * .3,
                        onPageChanged: (newPage, _) {
                          setState(() {
                            currentPage = newPage;
                          });
                        },
                      ),
                    ),
              VerticalSpacing(size: 10),
            ],
          ),
        )
      ],
    );
  }
}
