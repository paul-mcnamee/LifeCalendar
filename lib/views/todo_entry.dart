import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_calendar/views/todo_list_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:life_calendar/services/authentication.dart';

import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:life_calendar/components/snackbar.dart';

import 'package:life_calendar/models/application_state.dart';
import 'package:life_calendar/models/todo_model.dart';

class TodoEntry extends StatefulWidget {
  const TodoEntry({Key? key}) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoEntry> {
  late TextEditingController _controller;
  late Todo todo;
  late double _importance = 50;
  late bool _completed = false;

  @override
  void didUpdateWidget(covariant TodoEntry oldWidget) {
    setState(() {
      _completed = todo.completed;
      _importance = todo.importance;
      _controller.text = todo.entry;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = TextEditingController();

    setState(() {
      todo = new Todo(
          entry: '',
          date: currentDate,
          dateMS: currentDateMS,
          importance: 0.0,
          completed: false,
          archived: false,
          userId: FirebaseAuth.instance.currentUser!.uid);
      _completed = todo.completed;
      _importance = todo.importance;
      _controller.text = todo.entry;
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _currentTodo() => Center(
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.9,
            alignment: FractionalOffset.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter a new todo item!',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                  ],
                ),
                Expanded(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  child: TextField(
                    controller: _controller,
                    maxLength: 3000,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Enter a new todo item.",
                      labelStyle: TextStyle(fontSize: 16),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            var text = _controller.text;

                            ShowSnackBar.normal(context, "Updated todo.");
                            FocusScope.of(context).nextFocus();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Consumer<ApplicationState>(
                    builder: (context, appState, _) => Row(
                          children: [
                            if (appState.loginState ==
                                ApplicationLoginState.loggedIn)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          var todo = new Todo(
                                              entry: _controller.text,
                                              date: currentDate,
                                              dateMS: currentDateMS,
                                              importance: _importance,
                                              completed: _completed,
                                              archived: false,
                                              userId: FirebaseAuth
                                                  .instance.currentUser!.uid);
                                          todo.add();

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TodoListView()),
                                          );
                                        },
                                        child: Text("Submit"),
                                      )),
                                ],
                              ),
                          ],
                        ))
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).nextFocus(),
      child: Scaffold(
        body: _currentTodo(),
        appBar: buildAppBar("Add Todo"),
      ),
    );
  }
}
