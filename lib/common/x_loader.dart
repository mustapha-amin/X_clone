import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/images_paths.dart';
import '../core/core.dart';
import '/utils/utils.dart';
import '/theme/theme.dart';

class XLoader extends ConsumerWidget {
  const XLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeNotifierProvider);
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: context.screenWidth * .2,
            height: context.screenWidth * .2,
            child: const CircularProgressIndicator(color: AppColors.blueColor),
          ),
          GestureDetector(
            onTap: (){},
            child: SvgPicture.asset(
              ImagesPaths.x_icon,
              width: 30,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white : Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
