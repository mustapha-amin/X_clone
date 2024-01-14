import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/utils.dart';

class UserPostImageCarousel extends StatefulWidget {
  PostModel? post;
  XUser? user;
  UserPostImageCarousel({this.post, this.user, super.key});

  @override
  State<UserPostImageCarousel> createState() => _UserPostImageCarouselState();
}

class _UserPostImageCarouselState extends State<UserPostImageCarousel> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.post!.imagesUrl!
          .map((e) => Image.network(
                e,
                fit: BoxFit.cover,
              ))
          .toList(),
      options: CarouselOptions(
        initialPage: currentPage,
        enableInfiniteScroll: false,
        height: context.screenHeight * .4,
        onPageChanged: (newPage, _) {
          setState(() {
            currentPage = newPage;
          });
        },
      ),
    );
  }
}
