import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
    return CarouselSlider(
      items: [
        ...widget.pickedImages!.map(
          (image) => Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                image!,
                fit: BoxFit.cover,
                height: context.screenWidth * .7,
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    widget.pickedImages!.remove(image);
                  });
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ),
      ],
      options: CarouselOptions(
        viewportFraction: 0.7,
        height: context.screenWidth * .7,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
      ),
    );
  }
}
