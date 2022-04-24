import 'package:flutter/material.dart';
import 'package:life_calendar/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/todo_entry.dart';

// A single todo row.
class TodoItem extends StatelessWidget {
  TodoItem(this.todo, this.reference);

  final Todo todo;
  final DocumentReference<Todo> reference;

  Widget cardItem(BuildContext context) {
    return Card(
        color: Color.lerp(
            Colors.teal.shade900, Colors.teal.shade500, todo.importance / 100),
        borderOnForeground: true,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(
                          todo.completed
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: todo.completed ? Colors.teal.shade300 : null,
                        ),
                        tooltip: 'Mark the todo item as completed',
                        onPressed: () async {
                          await todo.complete(reference.id, !todo.completed);
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          splashColor: Colors.tealAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoEntry(
                                        inputTodo: todo,
                                        inputTodoId: reference.id,
                                      )),
                            );
                          },
                          child: Text('${todo.entry}')),
                    ),
                    // Edit icon doesn't seem necessary, I'll leave it in case
                    // others think it is necessary though.
                    // IconButton(
                    //   icon: Icon(Icons.edit),
                    //   tooltip: 'Edit the todo item',
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => TodoEntry(
                    //                 inputTodo: todo,
                    //                 inputTodoId: reference.id,
                    //               )),
                    //     );
                    //   },
                    // ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Delete the todo item',
                      onPressed: () async {
                        await todo.delete(reference.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  /// Returns todo details.
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
