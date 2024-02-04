import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/constants/firebase_constants.dart';
import 'package:x_clone/core/core.dart';
import 'package:x_clone/features/nav%20bar/nav_bar.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utils/dialog.dart';
import 'package:x_clone/utils/navigation.dart';
import '../../../utils/enums.dart';
import '../repository/auth_service.dart';
import '../repository/user_data_service.dart';

final userDataProvider =
    StateNotifierProvider<UserDataController, Status>((ref) {
  return UserDataController(
    userDataService: ref.watch(userDataServiceProvider),
    authService: ref.watch(authServiceProvider),
  );
});

final currentUserProvider = StreamProvider((ref) {
  final notifier = ref.watch(userDataProvider.notifier);
  final auth = ref.watch(authServiceProvider);
  return notifier.getUserInfo(auth.firebaseAuth.currentUser!.uid);
});

final userProviderWithID = StreamProvider.family<XUser?, String>((ref, uid) {
  final user = ref.watch(userDataProvider.notifier);
  return user.getUserInfo(uid);
});

final xUserDetailExistsProvider = FutureProvider((ref) async {
  final user = ref.watch(userDataProvider.notifier);
  return user.userDetailsExist();
});

class UserDataController extends StateNotifier<Status> {
  UserDataService? userDataService;
  AuthService? authService;

  UserDataController({this.userDataService, this.authService})
      : super(Status.initial);

  FutureVoid saveUserData(
    BuildContext context, {
    required String uid,
    required String email,
    required String name,
    required String username,
    required String bio,
    required String profilePath,
    required String coverpath,
  }) async {
    String? profilePicUrl, coverpicUrl;
    try {
      state = Status.loading;
      if (profilePath.isNotEmpty) {
        profilePicUrl = await userDataService!.updateImageUrl(uid, profilePath);
      }
      if (coverpath.isNotEmpty) {
        coverpicUrl = await userDataService!
            .updateImageUrl(uid, coverpath, isProfilePic: false);
      }
      XUser xUser = XUser(
        uid: uid,
        name: name,
        username: username,
        email: email,
        bio: bio,
        location: "",
        joined: DateTime.now(),
        followers: [],
        following: [],
        website: "",
        profilePicUrl: profilePicUrl ?? "",
        coverPicUrl: coverpicUrl ?? "",
        conversationList: [],
      );
      log(xUser.toString());
      await userDataService!.saveUserData(xUser);
      navigateAndReplace(context, XBottomNavBar());
      state = Status.success;
    } catch (e) {
      log('error');
      state = Status.failure;
      showErrorDialog(context: context, message: "An error occured");
    } finally {
      state = Status.initial;
    }
  }

  Stream<XUser?> getUserInfo(String? uid) {
    return userDataService!.fetchUserData(uid);
  }

  Future<bool?> userDetailsExist() async {
    bool exists = await userDataService!
        .userDetailsInDB(authService!.firebaseAuth.currentUser!.uid);
    return exists;
  }

  FutureVoid updateData(BuildContext context, List<String> fields,
      List<String> updatedData, String uid, WidgetRef ref) async {
    try {
      fields.forEach((field) async {
        String data = updatedData[fields.indexOf(field)];
        await ref
            .read(firestoreProvider)
            .collection(FirebaseConstants.usersCollection)
            .doc(uid)
            .update({
          field: data,
        });
      });
    } catch (e) {
      showErrorDialog(context: context, message: "An error occured");
    }
  }
}
