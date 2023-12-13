import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/services/user_data_db/user_data_service.dart';

final searchUsersProvider =
    StreamProvider.family<List<XUser>, String>((ref, name) {
  return ref.read(userDataServiceProvider).searchUser(name);
});
