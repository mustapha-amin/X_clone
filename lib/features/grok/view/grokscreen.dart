import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/utils/textstyle.dart';
import 'package:x_clone/utils/utils.dart';

class GrokScreen extends ConsumerWidget {
  const GrokScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: XAvatar(),
        title: Text(
          "Grok 3 (beta)",
          style: kTextStyle(15, ref, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        actions: [
          Icon(
            Icons.history,
            size: 28,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            FeatherIcons.edit,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ListView()),
          Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: Color(0xff202328),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ask anything",
                    hintStyle: kTextStyle(
                      12,
                      ref,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(spacing: 2, children: [
                      for (int i = 0; i < 4; i++) Icon(Icons.send_outlined)
                    ]),
                    Row(
                      children: [
                        Icon(Icons.tune),
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_upward,
                            color: Colors.grey[900],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ).padAll(8),
          ),
        ],
      ).padX(14).padY(3),
    );
  }
}
