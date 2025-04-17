import 'dart:io';

import 'package:flutter/material.dart';
import 'package:x_clone/utils/utils.dart';

class ImageCarousel extends StatefulWidget {
  List<File?>? pickedImages;
  ImageCarousel({this.pickedImages, super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
