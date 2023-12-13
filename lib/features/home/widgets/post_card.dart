import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/views/for%20you/post_detail_screen.dart';
import 'package:x_clone/features/home/widgets/post_icon_buttons.dart';
import 'package:x_clone/features/user_profile/views/user_profile_screen.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:x_clone/services/posts_db/post_service.dart';
import 'package:x_clone/utils/utils.dart';

class PostCard extends ConsumerStatefulWidget {
  PostModel? post;
  bool? isDetailScreen;
  PostCard({this.post, this.isDetailScreen = false, Key? key})
      : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  int currentPage = 0;

  bool isLiked(String uid) {
    return widget.post!.likesIDs!.contains(uid);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userProviderWithID(widget.post!.uid!)).when(
          data: (user) {
            return InkWell(
              onTap: () => navigateTo(
                  context,
                  PostDetailsScreen(
                    post: widget.post,
                    xUser: user,
                  )),
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
                      radius: 24,
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
                              widget.isDetailScreen! ? 22 : 19,
                              ref,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: " @${user.username}  ",
                                style: kTextStyle(
                                  widget.isDetailScreen! ? 14 : 13,
                                  ref,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: timeago.format(widget.post!.timeCreated!,
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
                            widget.isDetailScreen! ? 18 : 16,
                            ref,
                          ),
                        ),
                        Container(
                          width: context.screenWidth,
                          height: widget.isDetailScreen!
                              ? context.screenHeight * .45
                              : context.screenHeight * .3,
                          decoration: BoxDecoration(
                            border: const Border.symmetric(
                              vertical: BorderSide(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CarouselSlider(
                                items: [
                                  ...widget.post!.imagesUrl!.map(
                                    (e) => Image.network(
                                      e,
                                      errorBuilder: (context, _, __) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  initialPage: currentPage,
                                  enableInfiniteScroll: false,
                                  height: widget.isDetailScreen!
                                      ? context.screenHeight * .45
                                      : context.screenHeight * .3,
                                  onPageChanged: (newPage, _) {
                                    setState(() {
                                      currentPage = newPage;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                child: Text(
                                  "${currentPage + 1} / ${widget.post!.imagesUrl!.length}",
                                  style: kTextStyle(
                                    12,
                                    ref,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        VerticalSpacing(size: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PostIconButton(
                              iconData: FeatherIcons.messageCircle,
                              count: widget.post!.comments!.length,
                            ),
                            PostIconButton(
                              iconData: Icons.repeat,
                              count: widget.post!.repostCount,
                            ),
                            PostIconButton(
                              iconData: isLiked(ref.watch(uidProvider))
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              count: widget.post!.likesIDs!.length,
                              callback: () async {
                                isLiked(ref.watch(uidProvider))
                                    ? widget.post!.likesIDs!
                                        .remove(ref.watch(uidProvider))
                                    : widget.post!.likesIDs!
                                        .add(ref.watch(uidProvider));
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (_, __) => const Text("Error"),
          loading: () => const XLoader(),
        );
  }
}
