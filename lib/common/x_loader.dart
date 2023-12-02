import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/constants/svg_paths.dart';
import '/utils/utils.dart';
import '/theme/theme.dart';

class XLoader extends StatelessWidget {
  const XLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: context.screenWidth * .2,
              height: context.screenWidth * .2,
              child:
                  const CircularProgressIndicator(color: AppColors.blueColor),
            ),
            SvgPicture.asset(
              SvgPaths.x_icon,
              color: Colors.white,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
