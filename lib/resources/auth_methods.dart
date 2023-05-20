import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get User Details
  Future<model.User> getUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnapshot(snapshot);
  }

  /// Signup Method
  Future<String> signUp({
    required username,
    required email,
    required password,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';

    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && file.isNotEmpty) {
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
        final user = model.User(
          uid: uid,
          username: username,
          email: email,
          followers: [],
          following: [],
          profilePic: profilePic,
        );
        _firestore.collection('users').doc(uid).set(user.toJson());

        res = 'Success';
      } else {
        res = 'Please enter all the field';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Login Method
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'Success';
      } else {
        res = 'Please enter all the field';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
