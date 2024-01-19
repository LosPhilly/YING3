import 'package:ying_3_3/models/user.dart' as model;
import 'package:ying_3_3/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  late model.UserModel _user;
  final AuthMethods _authMethods = AuthMethods();

  model.UserModel get getUser => _user;

  Future<void> refreshUser() async {
    model.UserModel? user = await _authMethods.getUserDetails();
    _user = user!;
    notifyListeners();
  }

  void setUser(model.UserModel user) {
    _user = user;
    notifyListeners();
  }
}
