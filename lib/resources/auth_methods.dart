import 'dart:typed_data';

import 'package:ying_3_3/models/user.dart' as model;
import 'package:ying_3_3/resources/storage_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Get User details
  Future<model.User?> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          file != null) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage(
          'profilePics',
          file,
          false,
        );

        // add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Login in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all of the fields!';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

// Update user's credits
  Future<int> updateCredits(int credits) async {
    try {
      User currentUser = _auth.currentUser!;
      DocumentReference userRef =
          _firestore.collection('users').doc(currentUser.uid);

      await userRef.update({'credits': credits});
      return credits;
    } catch (err) {
      print(err.toString());
      return 0;
    }
  }

// Update user's credits
  Future<void> getCredits(int credits) async {
    try {
      User currentUser = _auth.currentUser!;
      DocumentReference userRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('credits')
          .doc('credits');

      await userRef.get();
    } catch (err) {
      print(err.toString());
    }
  }
}
