import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/common/shimmer.dart';
import 'package:x_clone/utils/utils.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerImage.circle(
          height: 40,
          width: 40,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerImage.rect(
                height: 5,
                width: 60,
              ),
              ...List.generate(
                3,
                (index) => ShimmerImage.rect(
                  height: 15,
                  width: index != 2 ? 75.w : 40.w,
                ).padY(2).padY(2),
              )
            ],
          ).padX(8),
        ),
      ],
    ).padAll(5);
  }
}
