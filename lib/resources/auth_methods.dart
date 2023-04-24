import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signup Method
  Future<String> signUp({
    required username,
    required email,
    required password,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';

    try {
      // Register user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save image to storage
      String profilePic = await StorageMethods().uploadImageToStorage(
        'profile',
        file,
        false,
      );

      // Add user to DB
      String uid = cred.user!.uid;
      _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'followers': [],
        'following': [],
        'profilePic': profilePic,
      });

      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
