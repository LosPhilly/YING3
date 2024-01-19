import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  final DateTime lastActive;
  final bool isOnline;

  const UserModel({
    required this.name,
    required this.imageURL,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      uid: snapshot["id"],
      email: snapshot["email"],
      imageURL: snapshot["userImage"],
      isOnline: false,
      lastActive: snapshot["lastActive"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": name,
        "uid": uid,
        "email": email,
        "photoUrl": imageURL,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['id'],
        name: json['name'],
        imageURL: json['userImage'],
        email: json['email'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );
}
