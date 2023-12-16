import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/features/auth/controller/user_data_controller.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/extensions.dart';
import 'package:x_clone/utils/utils.dart';

class EditProfile extends ConsumerStatefulWidget {
  XUser? user;
  EditProfile({this.user, super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  List<String> updatedFields = [];
  List<String> newData = [];

  @override
  initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user!.name);
    usernameController = TextEditingController(text: widget.user!.username);
    bioController = TextEditingController(text: widget.user!.bio);
    locationController = TextEditingController(text: widget.user!.location);
    websiteController = TextEditingController(text: widget.user!.website);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        actions: [
          ListenableBuilder(
            listenable: Listenable.merge([nameController, usernameController]),
            builder: (context, child) {
              bool fieldsNotEmpty = nameController.text.isNotEmpty &&
                  usernameController.text.isNotEmpty;
              return TextButton(
                onPressed: () async {
                  if (widget.user!.name != nameController.text) {
                    updatedFields.add("name");
                    newData.add(nameController.text.trim());
                  }
                  if (widget.user!.username != usernameController.text) {
                    updatedFields.add("username");
                    newData.add(usernameController.text.trim());
                  }
                  if (widget.user!.bio != bioController.text) {
                    updatedFields.add("bio");
                    newData.add(bioController.text.trim());
                  }
                  if (widget.user!.website != websiteController.text) {
                    updatedFields.add("website");
                    newData.add(websiteController.text.trim());
                  }
                  if (widget.user!.location != locationController.text) {
                    updatedFields.add("location");
                    newData.add(locationController.text.trim());
                  }
                  if (updatedFields.isNotEmpty) {
                    await userData.updateData(
                      context,
                      updatedFields,
                      newData,
                      widget.user!.uid!,
                      ref,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Save",
                  style: kTextStyle(
                    15,
                    ref,
                    color: fieldsNotEmpty ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: context.screenHeight * .3,
                  width: double.infinity,
                ),
                Container(
                  width: double.infinity,
                  height: context.screenHeight * .2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.user!.coverPicUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 5,
                  child: Container(
                    width: context.screenWidth * .25,
                    height: context.screenWidth * .25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.user!.profilePicUrl!),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            VerticalSpacing(size: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: kTextStyle(15,  ref,color: Colors.grey),
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: kTextStyle(15, ref, color: Colors.grey),
              ),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: "Bio",
                labelStyle: kTextStyle(15, ref, color: Colors.grey),
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Location",
                labelStyle: kTextStyle(15, ref, color: Colors.grey),
              ),
            ),
            TextField(
              controller: websiteController,
              decoration: InputDecoration(
                labelText: "Website",
                labelStyle: kTextStyle(15,  ref,color: Colors.grey),
              ),
            ),
          ],
        ).padX(10),
      ),
    );
  }
}
