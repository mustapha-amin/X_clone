import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/utils.dart';

class UserDetails extends ConsumerStatefulWidget {
  const UserDetails({super.key});

  @override
  ConsumerState<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  InputDecoration textfieldDecoration({String? hint}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      hintText: hint,
      hintStyle: kTextStyle(15, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            VerticalSpacing(size: 3),
            Text(
              "Profile setup",
              style: kTextStyle(
                25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                    child: Column(
                  children: [
                    VerticalSpacing(size: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: context.screenWidth * .2,
                          child: const Icon(
                            Icons.person,
                            size: 80,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -2,
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(Icons.photo_camera),
                          ),
                        )
                      ],
                    ),
                    VerticalSpacing(size: 20),
                    TextField(
                      focusNode: focusNode1,
                      controller: nameController,
                      decoration: textfieldDecoration(
                        hint: "Name",
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        focusNode1.unfocus();
                        FocusScope.of(context).requestFocus(focusNode2);
                      },
                    ),
                    VerticalSpacing(size: 10),
                    TextField(
                      focusNode: focusNode2,
                      controller: usernameController,
                      decoration: textfieldDecoration(
                        hint: "Username",
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        focusNode2.unfocus();
                        FocusScope.of(context).requestFocus(focusNode3);
                      },
                    ),
                    VerticalSpacing(size: 10),
                    TextField(
                      focusNode: focusNode3,
                      controller: bioController,
                      decoration: textfieldDecoration(
                        hint: "Bio",
                      ),
                      maxLength: 50,
                      textInputAction: TextInputAction.done,
                      maxLines: 3,
                      onSubmitted: (_) {
                        focusNode3.unfocus();
                      },
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(
              width: context.screenWidth,
              child: ListenableBuilder(
                listenable: Listenable.merge(
                  [
                    usernameController,
                    nameController,
                    bioController,
                  ],
                ),
                builder: (context, child) {
                  bool isEnabled = usernameController.text.isNotEmpty &&
                      nameController.text.isNotEmpty &&
                      bioController.text.isNotEmpty;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isEnabled ? AppColors.blueColor : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Next",
                      style: kTextStyle(17),
                    ),
                  );
                },
              ),
            )
          ],
        ).padX(20),
      ),
    );
  }
}
