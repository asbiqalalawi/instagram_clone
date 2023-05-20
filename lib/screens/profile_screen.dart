import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postData = [];
  int postLength = 0;
  int following = 0;
  int followers = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // get User Data
      final userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      // get Post Length
      final postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();

      setState(() {
        userData = userSnap.data()!;
        postData = postSnap.docs;
        postLength = postSnap.docs.length;
        following = userSnap.data()!['following'].length;
        followers = userSnap.data()!['followers'].length;
        isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['profilePic']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn('Posts', postLength),
                                    _buildStatColumn('Following', following),
                                    _buildStatColumn('Followers', followers),
                                  ],
                                ),
                                Row(
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? const FollowButton(
                                            backgroundColor: mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            textColor: primaryColor,
                                            text: 'Edit Profile',
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                textColor: Colors.black,
                                                text: 'Unfollow',
                                                onPressed: () {
                                                  FirestoreMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    widget.uid,
                                                  );
                                                  setState(() {
                                                    followers--;
                                                    isFollowing = false;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                textColor: Colors.white,
                                                text: 'Follow',
                                                onPressed: () {
                                                  FirestoreMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    widget.uid,
                                                  );
                                                  setState(() {
                                                    followers++;
                                                    isFollowing = true;
                                                  });
                                                })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Some description',
                        ),
                      ),
                      const Divider(),
                      // FutureBuilder(
                      //   future: ,
                      //   builder: (context, snapshot) => GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder),)
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: postLength,
                        // gridDelegate: const Silver(
                        //   crossAxisCount: 3,
                        //   crossAxisSpacing: 5,
                        //   mainAxisSpacing: 1.5,
                        //   childAspectRatio: 1,
                        // ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) => Image(
                          image: NetworkImage(
                            postData[index]['postUrl'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildStatColumn(String label, int num) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
