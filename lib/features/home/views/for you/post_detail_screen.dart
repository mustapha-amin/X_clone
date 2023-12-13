import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/home/widgets/post_card.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/utils.dart';

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

  bool isLiked(String uid) {
    return widget.post!.likesIDs!.contains(uid);
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
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: "Post your reply",
              hintStyle: kTextStyle(15, ref, color: Colors.grey),
            ),
          ).padX(10),
        ],
      ),
    );
  }
}
