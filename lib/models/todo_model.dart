import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:life_calendar/services/authentication.dart';

@immutable
class Todo {
  Todo({
    required this.entry,
    required this.date,
    required this.dateMS,
    required this.importance,
    required this.completed,
    required this.archived,
    required this.userId,
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          entry: json['entry'] as String,
          date: (json['date']! as Timestamp).toDate(),
          dateMS: json['dateMS']! as int,
          importance: json['importance']! as double,
          completed: (json['completed'] ?? false) as bool,
          archived: (json['archived'] ?? false) as bool,
          userId: json['userId']! as String,
        );

  final String entry;
  final DateTime date;
  final int dateMS;
  final double importance;
  final bool completed;
  final bool archived;
  final String userId;

  Map<String, Object?> toJson() {
    return {
      'entry': entry,
      'date': date,
      'dateMS': dateMS,
      'importance': importance,
      'completed': completed,
      'archived': archived,
      'userId': userId,
    };
  }

  Future<void> add() async {
    await FirebaseFirestore.instance.collection('todos').add(<String, dynamic>{
      'completed': completed,
      'date': date,
      'dateMS': dateMS,
      'entry': entry,
      'importance': importance,
      'archived': false,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> archive(String id, bool archived) async {
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(id)
        .update(<String, dynamic>{
      'archived': archived,
    });
  }

  Future<void> complete(String id, bool completed) async {
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(id)
        .update(<String, dynamic>{
      'completed': completed,
    });
  }

  Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection('todos').doc(id).delete();
  }
}

class TodoModel extends ChangeNotifier {
  TodoModel() {
    init();
  }

  Future<void> init() async {}
}
