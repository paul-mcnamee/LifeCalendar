import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/views/todo_list_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:life_calendar/services/authentication.dart';

import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:life_calendar/components/snackbar.dart';

import 'package:life_calendar/models/application_state.dart';
import 'package:life_calendar/models/todo_model.dart';

NumberFormat numberFormat = NumberFormat("#", "en-us");

class TodoEntry extends StatefulWidget {
  const TodoEntry(
      {Key? key, required this.inputTodo, required this.inputTodoId})
      : super(key: key);

  final Todo? inputTodo;
  final String? inputTodoId;

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoEntry> {
  late TextEditingController _controller;
  late Todo todo;
  late double _importance = 50;
  late bool _completed = false;
  bool isEditMode = false;

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
      if (widget.inputTodo != null) {
        todo = widget.inputTodo!;
        isEditMode = true;
      } else {
        todo = new Todo(
            entry: '',
            date: currentDate,
            dateMS: currentDateMS,
            importance: 0.0,
            completed: false,
            archived: false,
            userId: FirebaseAuth.instance.currentUser!.uid);
      }

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
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter a new todo item',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                  ],
                ),
                // Rating slider and impactful star
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [Text("How important is this?")],
                          ),
                          Row(
                            children: [
                              Slider(
                                value: _importance,
                                label: numberFormat.format(_importance),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _importance = value;
                                  });
                                },
                              ),
                            ],
                          )
                        ]),
                  ],
                ),
                TextField(
                  controller: _controller,
                  maxLength: 300,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "What needs to get done?",
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
                                          if (isEditMode) {
                                            await todo.update(
                                                widget.inputTodoId ?? "",
                                                _controller.text,
                                                _importance);
                                          } else {
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
                                          }

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
                        )),
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
        bottomNavigationBar: Container(child: AdaptiveBannerAd()),
      ),
    );
  }
}
