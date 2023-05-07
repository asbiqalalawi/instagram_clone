import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  void _moreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: ['Delete']
              .map(
                (e) => InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(e),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ).copyWith(
            right: 0,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1682621034494-2242e054972c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _moreDialog(context),
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ),

        // IMAGE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.network(
            'https://images.unsplash.com/photo-1683294163345-1cd8cd02147f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
            fit: BoxFit.cover,
          ),
        ),

        // Likes and comments
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.comment),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_outlined),
                ),
              ),
            ),
          ],
        ),

        // Description and number of comments
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
              child: Text(
                '1,123 likes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: primaryColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' description of post',
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'View all 200 comments',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                '07/05/2023',
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
