import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/views/todo_entry.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoEntry()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      appBar: buildAppBar("Todo List"),
    );
  }
}
