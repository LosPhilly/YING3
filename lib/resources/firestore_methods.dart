import 'dart:typed_data';

import 'package:ying_3_3/resources/storage_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';
import '../models/user.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'Some error occured!';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('post', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('post').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // DELETING POST
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('post').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> storeNotification(
      String uid, String taskId, String type, String postUrl) async {
    try {
      // Get the user's data
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();

      // Get the user's username and profile picture URL
      String username = (userSnapshot.data()! as dynamic)['name'];
      String profilePictureUrl = (userSnapshot.data()! as dynamic)['userImage'];

      // Create the notification message based on the type of notification
      String? message;
      if (type == 'like') {
        message = '$username liked your gig.';
      } else if (type == 'comment') {
        message = '$username commented on your gig.';
      } else if (type == 'participate') {
        message = '$username applied to your gig.';
      }

      // Add the notification to the post owner's notifications subcollection
      DocumentSnapshot postSnapshot =
          await _firestore.collection('tasks').doc(taskId).get();
      String postOwnerId = (postSnapshot.data()! as dynamic)['uploadedBy'];
      await _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('notifications')
          .add({
        'type': type,
        'message': message,
        'postId': taskId,
        'postUrl': postUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'profilePictureUrl': profilePictureUrl,
      });
    } catch (e) {
      print('Error storing notification: $e');
    }
  }
}
