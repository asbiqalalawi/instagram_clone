import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
}
