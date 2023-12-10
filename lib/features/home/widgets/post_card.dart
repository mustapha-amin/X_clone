import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/features/home/widgets/post_icon_buttons.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel? post;
  PostCard({required this.post, Key? key}) : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(otherUserProvider(widget.post!.uid!)).when(
          data: (user) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.profilePicUrl!),
                  radius: 24,
                ),
                HorizontalSpacing(size: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name!,
                            style: kTextStyle(16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '@${user.username!}',
                            style: kTextStyle(14, color: Colors.grey),
                          ),
                        ],
                      ),
                      VerticalSpacing(size: 5),
                      Text(
                        widget.post!.text!,
                        style: kTextStyle(16),
                      ),
                      SizedBox(
                        width: context.screenWidth,
                        height: context.screenHeight * .3,
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                widget.post!.imagesUrl!.length == 1 ? 1 : 2,
                          ),
                          children: [
                            ...widget.post!.imagesUrl!.map(
                              (image) => Image.network(
                                image,
                                fit: BoxFit.contain,
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
                            iconData: Icons.favorite_border,
                            count: widget.post!.likesIDs!.length,
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
            );
          },
          error: (_, __) => const Text("Error"),
          loading: () => const XLoader(),
        );
  }
}
