import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class ExtraIconButtons extends StatelessWidget {
  const ExtraIconButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.checklist_rounded,
            color: AppColors.blueColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.blueColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.circle_outlined,
            color: Colors.grey[600],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add_circle,
            color: AppColors.blueColor,
          ),
        ),
      ],
    );
  }
}
