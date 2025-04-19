import 'package:flutter/material.dart';
import 'package:x_clone/features/home/views/images_view.dart';
import 'package:x_clone/utils/utils.dart';

class PostImages extends StatelessWidget {
  final List<String> images;

  const PostImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    Widget imageTile(
      String url, {
      bool? topLeft,
      bool? topRight,
      bool? bottomLeft,
      bool? bottomRight,
    }) {
      return GestureDetector(
        onTap: () => navigateTo(context,
            ImagesView(images: images, currentIndex: images.indexOf(url))),
        child: ClipRRect(
          borderRadius: topLeft == null &&
                  topRight == null &&
                  bottomLeft == null &&
                  bottomRight == null
              ? BorderRadius.circular(18)
              : BorderRadius.only(
                  topLeft:
                      topLeft == true ? const Radius.circular(18) : Radius.zero,
                  topRight: topRight == true
                      ? const Radius.circular(18)
                      : Radius.zero,
                  bottomLeft: bottomLeft == true
                      ? const Radius.circular(18)
                      : Radius.zero,
                  bottomRight: bottomRight == true
                      ? const Radius.circular(18)
                      : Radius.zero,
                ),
          child: Hero(
            tag: url,
            child: Image.network(
              url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: () {
        if (images.length == 1) {
          return imageTile(images[0]);
        } else if (images.length == 2) {
          return Row(
            children: [
              Expanded(
                  child: imageTile(images[0], topLeft: true, bottomLeft: true)),
              const SizedBox(width: 4),
              Expanded(
                  child:
                      imageTile(images[1], topRight: true, bottomRight: true)),
            ],
          );
        } else if (images.length == 3) {
          return Row(
            children: [
              Expanded(
                  child: imageTile(images[0], topLeft: true, bottomLeft: true)),
              const SizedBox(width: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    Expanded(child: imageTile(images[1], topRight: true)),
                    const SizedBox(height: 4),
                    Expanded(child: imageTile(images[2], bottomRight: true)),
                  ],
                ),
              ),
            ],
          );
        } else {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  imageTile(
                    images[index],
                    topLeft: index == 0,
                    topRight: index == 1,
                    bottomLeft: index == 2,
                    bottomRight: index == 3,
                  ),
                  if (index == 3 && images.length > 4)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      alignment: Alignment.center,
                      child: Text(
                        '+${images.length - 4}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        }
      }(),
    );
  }
}
