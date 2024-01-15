import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/spacing.dart';
import 'package:x_clone/utils/textstyle.dart';

class MessageUser extends ConsumerStatefulWidget {
  final XUser xUser;
  const MessageUser({required this.xUser, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageUserState();
}

class _MessageUserState extends ConsumerState<MessageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.xUser.profilePicUrl!),
            ),
            HorizontalSpacing(size: 10),
            Text(
              widget.xUser.name!,
              style: kTextStyle(20, ref, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefix: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.photo),
              ),
            ),
          ).padAll(35)
        ],
      ),
    );
  }
}
