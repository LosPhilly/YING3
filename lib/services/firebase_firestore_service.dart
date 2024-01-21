import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:ying_3_3/models/message.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:ying_3_3/services/firebase_storage_service.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;
  String messageId = Uuid().v4();

  static Future<void> createUser({
    required String name,
    required String image,
    required String email,
    required String uid,
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      imageURL: image,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    await firestore.collection('users').doc(uid).set(user.toJson());
  }

  Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      messageID: messageId,
      isLiked: false,
      unread: true,
    );
    await _addMessageToChat(receiverId, messageId, message);
  }

  Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    final uuid = Uuid(); // Create a Uuid instance to generate UUIDs
    final imageName =
        '${uuid.v4()}.jpg'; // Generate a random UUID and use it in the image name

    final image = await FirebaseStorageService.uploadImage(
      file,
      'image/chat/$imageName', // Use the generated image name
    );

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageID: messageId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      isLiked: false,
      unread: true,
    );
    await _addMessageToChat(receiverId, messageId, message);
  }

  Future<void> _addMessageToChat(
    String receiverId,
    String messageId,
    Message message,
  ) async {
    // When sending a message, create a unique message ID

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  static Future<List<UserModel>> searchUser(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
}
