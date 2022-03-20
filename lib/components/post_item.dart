import 'package:flutter/material.dart';
import 'package:life_calendar/components/post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// A single post row.
class PostItem extends StatelessWidget {
  PostItem(this.post, this.reference);

  final Post post;
  final DocumentReference<Post> reference;

  Widget get rating {
    return Text(
      'R: ${post.rating}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get impactful {
    return Text(
      'I: ${post.impactful}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get date {
    return Text(
      'H: ${post.date}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Return the movie title.
  Widget get entry {
    return Text(
      '${post.entry}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Returns movie details.
  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rating,
          impactful,
          date,
          entry,
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
          Flexible(child: details),
        ],
      ),
    );
  }
}