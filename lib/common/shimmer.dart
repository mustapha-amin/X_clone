import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatelessWidget {
  final double height, width;
  final BoxShape boxShape;

  const ShimmerImage._({
    required this.height,
    required this.width,
    required this.boxShape,
  });

  factory ShimmerImage.circle({required double height, required double width}) {
    return ShimmerImage._(
      height: height,
      width: width,
      boxShape: BoxShape.circle,
    );
  }

  factory ShimmerImage.rect({required double height, required double width}) {
    return ShimmerImage._(
      height: height,
      width: width,
      boxShape: BoxShape.rectangle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 300),
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        decoration: BoxDecoration(
          shape: boxShape,
          borderRadius:
              boxShape == BoxShape.rectangle ? BorderRadius.circular(5) : null,
          color: Colors.grey[700],
        ),
        width: width,
        height: height,
      ),
    );
  }
}
