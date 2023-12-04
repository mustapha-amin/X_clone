import 'dart:developer';
import 'dart:io';
import 'package:x_clone/constants/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
  ValueNotifier<bool> nameFieldTapped = ValueNotifier(false);
  ValueNotifier<bool> usernameFieldTapped = ValueNotifier(false);
  ValueNotifier<bool> bioFieldTapped = ValueNotifier(false);
  ValueNotifier<String?> nameErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> usernameErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> bioErrorText = ValueNotifier<String?>(null);
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  File? profileImage;
  File? coverImage;

  toggleFieldsTapped() {
    nameFieldTapped.value = true;
    usernameFieldTapped.value = true;
    bioFieldTapped.value = true;
  }

  Future<void> selectImage({bool? isProfileImage = true}) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null && isProfileImage!) {
        setState(() {
          profileImage = File(image.path);
        });
      } else if (image != null && !isProfileImage!) {
        setState(() {
          coverImage = File(image.path);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void displayNameError() {
    if (nameController.text.isEmpty) {
      nameErrorText.value = "name cannot be empty";
    } else {
      nameErrorText.value = null;
    }
  }

  void displayUsernameError() {
    if (usernameController.text.isEmpty) {
      nameErrorText.value = "username cannot be empty";
    } else {
      usernameErrorText.value = null;
    }
  }

  void displayBioError() {
    if (bioController.text.isEmpty) {
      bioErrorText.value = "bio cannot be empty";
    } else {
      bioErrorText.value = null;
    }
  }

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
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              InkWell(
                                onTap: () => selectImage(isProfileImage: false),
                                child: Container(
                                  height: context.screenHeight * .2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.withOpacity(0.3),
                                    image: coverImage != null
                                        ? DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: FileImage(coverImage!),
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.photo_camera_outlined,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 45,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 5,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: context.screenWidth * .17,
                                      height: context.screenWidth * .17,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        color: Colors.grey.withOpacity(0.3),
                                        image: profileImage != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(profileImage!),
                                              )
                                            : null,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => selectImage(),
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        size: 30,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      VerticalSpacing(size: 40),
                      ValueListenableBuilder(
                        valueListenable: nameErrorText,
                        builder: (context, error, _) {
                          return TextField(
                            focusNode: focusNode1,
                            controller: nameController,
                            decoration: textfieldDecoration(
                              hint: "Name",
                            ).copyWith(
                              errorText: error,
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              focusNode1.unfocus();
                              FocusScope.of(context).requestFocus(focusNode2);
                            },
                            onChanged: (_) {
                              if (nameFieldTapped.value) {
                                displayNameError();
                              }
                            },
                          );
                        },
                      ),
                      VerticalSpacing(size: 10),
                      ValueListenableBuilder(
                        valueListenable: usernameErrorText,
                        builder: (context, error, _) {
                          return TextField(
                            focusNode: focusNode2,
                            controller: usernameController,
                            decoration: textfieldDecoration(
                              hint: "username",
                            ).copyWith(
                              errorText: error,
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              focusNode2.unfocus();
                              FocusScope.of(context).requestFocus(focusNode3);
                            },
                            onChanged: (_) {
                              if (usernameFieldTapped.value) {
                                displayBioError();
                              }
                            },
                          );
                        },
                      ),
                      VerticalSpacing(size: 10),
                      ValueListenableBuilder(
                        valueListenable: bioErrorText,
                        builder: (context, error, _) {
                          return TextField(
                            focusNode: focusNode3,
                            controller: bioController,
                            decoration: textfieldDecoration(
                              hint: "Bio",
                            ).copyWith(
                              errorText: error,
                            ),
                            maxLength: 50,
                            textInputAction: TextInputAction.done,
                            maxLines: 3,
                            onSubmitted: (_) {
                              focusNode3.unfocus();
                            },
                            onChanged: (_) {
                              if (bioFieldTapped.value) {
                                displayBioError();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
                    onPressed: () {
                      if (usernameController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          bioController.text.isNotEmpty) {
                        try {
                          
                        } catch (e) {}
                      } else {
                        toggleFieldsTapped();
                        displayNameError();
                        displayBioError();
                        displayUsernameError();
                      }
                    },
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
