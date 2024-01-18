import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/models/user.dart';

class FirebaseProvider extends ChangeNotifier {
  List<User> users = [];

  List<User> getAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users = users.docs.map((doc) => User.fromJson(doc.data())).toList();
      notifyListeners();
    });
    return users;
  }
}
