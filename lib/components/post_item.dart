import 'package:flutter/material.dart';
import 'package:life_calendar/components/post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_calendar/views/daily_entry.dart';

// A single post row.
class PostItem extends StatelessWidget {
  PostItem(this.post, this.reference);

  final Post post;
  final DocumentReference<Post> reference;

  Widget get date {
    return Text(
      '${post.date.year}-${post.date.month}-${post.date.day}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Return the post entry text.
  Widget get entry {
    return Row(
      children: [
        Flexible(
          child: Text('${post.entry}'),
        )
      ],
    );
  }

  Widget get header {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Icon(
            post.impactful ? Icons.star : Icons.star_border,
            color: post.impactful ? Colors.yellow : null,
          ),
        ]),
        Column(children: <Widget>[
          date,
        ]),
      ],
    );
  }

  Widget cardItem(BuildContext context) {
    return Card(
        color: Color.lerp(Colors.black, Colors.green, post.rating / 100),
        borderOnForeground: true,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: InkWell(
            splashColor: Colors.tealAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DailyEntry(
                          inputPost: post,
                        ),
                    settings: RouteSettings(arguments: post.date)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: header,
                ),
                entry,
              ],
            ),
          ),
        ));
  }

  /// Returns post details.
  Widget cardContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardItem(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: cardContainer(context)),
        ],
      ),
    );
  }
}
