class User {
  final String uid;
  final String username;
  final String email;
  final List followers;
  final List following;
  final String profilePic;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.followers,
    required this.following,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'followers': [],
        'following': [],
        'profilePic': profilePic,
      };
}
