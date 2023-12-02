import 'package:flutter/material.dart';

void showErrorDialog({BuildContext? context, String? message}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          )
        ],
      );
    },
  );
}
