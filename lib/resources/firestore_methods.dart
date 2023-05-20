import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profilePic,
  ) async {
    String res = 'Success';

    try {
      // Upload image to Firebase Storage
      String postUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      // Generate UID
      String postId = const Uuid().v1();

      // Convert to Post Model
      Post post = Post(
        postId: postId,
        description: description,
        uid: uid,
        username: username,
        postUrl: postUrl,
        profilePic: profilePic,
        date: DateTime.now(),
        likes: [],
      );

      // Store data to Firestore
      _firestore.collection('posts').doc(postId).set(post.toJson());
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String username,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'uid': uid,
          'username': username,
          'text': text,
          'commentId': commentId,
          'date': DateTime.now(),
        });
      } else {
        debugPrint('Text is empty!');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      List following = snapshot.data()!['following'];

      if (following.contains(uid)) {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
