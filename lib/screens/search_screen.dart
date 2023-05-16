import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isShowUsers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (value) {
            debugPrint(value);
            setState(() {
              isShowUsers = true;
            });
          },
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['profilePic'],
                      ),
                    ),
                    title: Text(snapshot.data!.docs[index]['username']),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Posts'),
            ),
    );
  }
}
