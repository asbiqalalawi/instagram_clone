import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String description;
  final String uid;
  final String username;
  final String postUrl;
  final String profilePic;
  final DateTime date;
  final List likes;

  const Post({
    required this.postId,
    required this.description,
    required this.uid,
    required this.username,
    required this.postUrl,
    required this.profilePic,
    required this.date,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'description': description,
    'uid': uid,
    'username': username,
    'postUrl': postUrl,
    'profilePic': profilePic,
    'date': date,
    'likes': likes,
  };

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
      postId: snap['postId'],
      description: snap['description'],
      uid: snap['uid'],
      username: snap['username'],
      postUrl: snap['postUrl'],
      profilePic: snap['profilePic'],
      date: snap['date'],
      likes: snap['likes'],
    );
  }
}
