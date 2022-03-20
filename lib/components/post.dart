import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Post {
  Post({
    required this.entry,
    required this.date,
    required this.dateMS,
    required this.rating,
    required this.impactful,
    required this.userId,
  });

  Post.fromJson(Map<String, Object?> json)
      : this(
    entry: json['entry'] as String,
    date: (json['date']! as Timestamp).toDate(),
    dateMS: json['dateMS']! as int,
    rating: json['rating']! as double,
    impactful: (json['impactful'] ?? false) as bool,
    userId: json['userId']! as String,
  );

  final String entry;
  final DateTime date;
  final int dateMS;
  final double rating;
  final bool impactful;
  final String userId;

  Map<String, Object?> toJson() {
    return {
      'entry': entry,
      'date': date,
      'dateMS': dateMS,
      'rating': rating,
      'impactful': impactful,
      'userId': userId,
    };
  }
}