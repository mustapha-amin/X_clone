// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone/common/x_loader.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/theme/pallete.dart';
import 'package:x_clone/utils/utils.dart';

import '../../../utils/enums.dart';
import '../../nav bar/nav_bar.dart';

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
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  ValueNotifier<File?>? profileImage;
  ValueNotifier<File?>? coverImage;

  Future<void> selectImage({bool? isProfileImage = true}) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null && isProfileImage!) {
        setState(() {
          profileImage = ValueNotifier(File(image.path));
        });
      } else if (image != null && !isProfileImage!) {
        setState(() {
          coverImage = ValueNotifier(File(image.path));
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  InputDecoration textfieldDecoration({String? hint}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      hintText: hint,
      hintStyle: kTextStyle(15, ref, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Status status = ref.watch(userDataProvider);
    return SafeArea(
      child: Scaffold(
        body: status == Status.loading
            ? const XLoader()
            : Column(
                children: [
                  VerticalSpacing(size: 3),
                  Text(
                    "Profile setup",
                    style: kTextStyle(
                      25,
                      ref,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: SingleChildScrollView(
                        child: Center(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  VerticalSpacing(size: 20),
                                  InkWell(
                                    onTap: () =>
                                        selectImage(isProfileImage: false),
                                    child: Container(
                                      height: context.screenHeight * .2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.withOpacity(0.3),
                                        image: coverImage != null
                                            ? DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: FileImage(
                                                    coverImage!.value!),
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
                                  VerticalSpacing(size: 50),
                                  TextFormField(
                                    focusNode: focusNode1,
                                    controller: nameController,
                                    decoration: textfieldDecoration(
                                      hint: "Name",
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      focusNode1.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(focusNode2);
                                    },
                                    validator: (name) {
                                      if (name!.isEmpty) {
                                        return "name cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  VerticalSpacing(size: 10),
                                  TextFormField(
                                    focusNode: focusNode2,
                                    controller: usernameController,
                                    decoration: textfieldDecoration(
                                      hint: "username",
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      focusNode2.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(focusNode3);
                                    },
                                    validator: (username) {
                                      if (username!.isEmpty) {
                                        return "username cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  VerticalSpacing(size: 10),
                                  TextFormField(
                                    focusNode: focusNode3,
                                    controller: bioController,
                                    decoration: textfieldDecoration(
                                      hint: "Bio",
                                    ),
                                    maxLength: 50,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 3,
                                    onFieldSubmitted: (_) {
                                      focusNode3.unfocus();
                                    },
                                    validator: (bio) {
                                      if (bio!.isEmpty) {
                                        return "bio cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 15,
                                top: 100,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => selectImage(),
                                  child: Container(
                                    width: context.screenWidth * .22,
                                    height: context.screenWidth * .22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                      color: Colors.grey[800],
                                      image: profileImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  profileImage!.value!),
                                            )
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.photo_camera_outlined,
                                      size: 30,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                          coverImage,
                          profileImage,
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                ref.read(userDataProvider.notifier).saveUserData(
                                      context,
                                      uid: ref.watch(uidProvider),
                                      email: ref
                                          .watch(userProvider)!
                                          .providerData[0]
                                          .email!,
                                      name: nameController.text.trim(),
                                      username: usernameController.text.trim(),
                                      bio: bioController.text.trim(),
                                      profilePath:
                                          profileImage!.value! != null
                                              ? profileImage!.value!.path
                                              : "",
                                      coverpath: coverImage!.value! != null
                                          ? coverImage!.value!.path
                                          : "",
                                    );
                                // ignore: use_build_context_synchronously
                                
                              } catch (e) {
                                log(e.toString());
                              }
                            } else {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          },
                          child: Text(
                            "Next",
                            style: kTextStyle(
                              17,
                              ref,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ).padX(15),
      ),
    );
  }
}
