import 'package:x_clone/core/core.dart';
import 'package:x_clone/models/user_model.dart';

abstract class BaseUserDataService {
  FutureVoid saveUserData(XUser xuser);
}
