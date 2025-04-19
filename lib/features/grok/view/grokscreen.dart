import 'dart:async';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/common/x_avatar.dart';
import 'package:x_clone/core/providers.dart';
import 'package:x_clone/utils/textstyle.dart';
import 'package:x_clone/utils/utils.dart';

class GrokScreen extends ConsumerStatefulWidget {
  const GrokScreen({super.key});

  @override
  ConsumerState<GrokScreen> createState() => _GrokScreenState();
}

class _GrokScreenState extends ConsumerState<GrokScreen> {
  final grokController = StreamController<List<String>>.broadcast();
  List<String> messages = [];
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String reverseString(String str) => str.split('').reversed.join('');

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    messages.add(message);
    grokController.sink.add(messages);
    scrollToBottom();

    Future.delayed(Duration(milliseconds: 500), () {
      messages.add(reverseString(message));
      grokController.sink.add(messages);
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    grokController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: XAvatar(),
        title: Text(
          "Grok 3 (beta)",
          style: kTextStyle(15, ref, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        actions: [
          Icon(Icons.history,
              size: 28, color: isDark ? Colors.white : Colors.black),
          SizedBox(width: 20),
          Icon(FeatherIcons.edit, color: isDark ? Colors.white : Colors.black),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: grokController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Start chatting with Grok!',
                        style: kTextStyle(14, ref, color: Colors.grey),
                      ),
                    );
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    padding: EdgeInsets.only(top: 8, bottom: 30),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = index % 2 == 0;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isUser ? Color(0xff202328) : Colors.grey[700],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message,
                            style: kTextStyle(16, ref, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 8),
              decoration: BoxDecoration(
                color: isDark ? Color(0xff202328) : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textEditingController,
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      sendMessage(value.trim());
                      textEditingController.clear();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ask anything",
                      hintStyle: kTextStyle(12, ref, color: Colors.grey[600]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.tune),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                        ),
                        onPressed: () {
                          sendMessage(textEditingController.text.trim());
                          textEditingController.clear();
                        },
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[900]),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).padX(14).padY(3),
      ),
    );
  }
}
