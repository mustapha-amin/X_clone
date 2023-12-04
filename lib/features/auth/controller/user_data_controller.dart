import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/services/auth/auth_service.dart';
import 'package:x_clone/services/database/user_data_service.dart';
import 'package:x_clone/utils/dialog.dart';

enum Status {
  initial,
  loading,
  failure,
  success,
}

class UserDataController extends StateNotifier<Status> {
  UserDataService? userDataService;
  AuthService? authService;

  UserDataController({this.userDataService, this.authService})
      : super(Status.initial);

  FutureVoid saveUserData(
    BuildContext context, {
    Ref? ref,
    String? name,
    String? username,
    String? bio,
    String? profilePicUrl,
    String? coverPicUrl,
  }) async {
    state = Status.loading;
    XUser xUser = XUser(
      uid: ref!.watch(userProvider)!.uid,
      name: name!,
      username: username!,
      email: ref.watch(userProvider)!.email!,
      bio: bio!,
      tweetCount: 0,
      likesCount: 0,
      location: "",
      joined: DateTime.now(),
      followers: [],
      following: [],
      website: "",
      profilePicUrl: profilePicUrl!,
      coverPicUrl: coverPicUrl!,
    );
    try {
      XUser? updatedUser;
      if (xUser.profilePicUrl.isNotEmpty) {
        updatedUser = await userDataService!.updateImageUrl(
          xUser,
          profilePicUrl,
        );
      }
      if (xUser.coverPicUrl.isNotEmpty) {
        updatedUser = await userDataService!.updateImageUrl(
          xUser,
          coverPicUrl,
          isProfilePic: false,
        );
      }
      await userDataService!.saveUserData(updatedUser!);
      state = Status.success;
    } catch (e) {
      state = Status.failure;
      if (context.mounted) {
        showErrorDialog(context: context, message: "An error occured");
      }
    }
  }
}
