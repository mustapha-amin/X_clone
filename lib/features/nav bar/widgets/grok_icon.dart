import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';

class GrokIcon extends ConsumerWidget {
  final bool selected;
  const GrokIcon({required this.selected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(
            ImagesPaths.grok,
            width: 18,
            colorBlendMode: BlendMode.srcIn,
            color: selected ? Colors.black : Colors.white,
          ),
          Text(
            "GROK",
            style: kTextStyle(8, ref,
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900),
          )
        ],
      ).padX(4).padY(2),
    );
  }
}
