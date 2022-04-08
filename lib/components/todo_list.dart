import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_calendar/components/todo_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
// A reference to the list of todos.
// We are using `withConverter` to ensure that interactions with the collection
// are type-safe.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Todo>>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .withConverter<Todo>(
            fromFirestore: (snapshots, _) => Todo.fromJson(snapshots.data()!),
            toFirestore: (todoItem, _) => todoItem.toJson(),
          )
          .orderBy('completed')
          .orderBy('importance', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return TodoItem(
              data.docs[index].data(),
              data.docs[index].reference,
            );
          },
        );
      },
    );
  }
}
