import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/images_paths.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/textstyle.dart';

class GrokIcon extends ConsumerWidget {
  final bool selected;
  const GrokIcon({required this.selected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: switch (ref.watch(themeNotifierProvider)) {
          true => selected ? Colors.white : Colors.black,
          false => selected ? Colors.black : Colors.white,
        },
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.asset(
            ImagesPaths.grok,
            width: 18,
            colorBlendMode: BlendMode.srcIn,
            color: switch (ref.watch(themeNotifierProvider)) {
              true => selected ? Colors.black : Colors.white,
              false => selected ? Colors.white : Colors.black,
            },
          ),
          Text(
            "GROK",
            style: kTextStyle(8, ref,
                color: switch (ref.watch(themeNotifierProvider)) {
                  true => selected ? Colors.black : Colors.white,
                  false => selected ? Colors.white : Colors.black,
                },
                fontWeight: FontWeight.w900),
          )
        ],
      ).padX(4).padY(2),
    );
  }
}
