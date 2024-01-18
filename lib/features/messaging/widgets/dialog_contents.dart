import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:x_clone/features/messaging/controller/message_controller.dart';
import 'package:x_clone/models/message_model.dart';

import '../../../core/providers.dart';
import '../../../utils/utils.dart';

class DialogContent extends ConsumerWidget {
  final Message message;
  const DialogContent({required this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        message.senderID != ref.watch(uidProvider)
            ? const SizedBox()
            : ListTile(
                splashColor: Colors.transparent,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Delete message",
                          style: kTextStyle(18, ref),
                        ),
                        content: Text(
                          "Do you want to delete this message",
                          style: kTextStyle(15, ref),
                        ),
                        actionsAlignment: MainAxisAlignment.end,
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref.read(deleteMessageProvider(message));
                               Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              
                            },
                            child: Text(
                              "Yes",
                              style: kTextStyle(14, ref, color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                             
                            },
                            child: Text(
                              "No",
                              style: kTextStyle(14, ref),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                title: Text(
                  "Delete",
                  style: kTextStyle(
                    15,
                    ref,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                
              ),),
        ListTile(
          splashColor: Colors.transparent,
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(text: message.content!),
            );
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 500),
                content: Text("Copied to clipboard"),
              ),
            );
          },
          title: Text(
            "Copy to clipboard",
            style: kTextStyle(
              15,
              ref,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          title: Text(
            "Cancel",
            style: kTextStyle(
              15,
              ref,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
