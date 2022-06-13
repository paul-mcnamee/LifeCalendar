import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:life_calendar/components/adaptive_banner_ad.dart';
import 'package:life_calendar/components/post.dart';
import 'package:life_calendar/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:life_calendar/components/snackbar.dart';
import 'package:life_calendar/models/application_state.dart';
import 'package:life_calendar/models/daily_entry_model.dart';
import 'package:life_calendar/views/settings.dart';

// TODO: add a setting for selecting date format -- test for regional defaults
//      Ideally there should be a utility for just getting the date with this format
DateFormat dateFormat = DateFormat("yyyy-MM-dd");
NumberFormat numberFormat = NumberFormat("#", "en-us");

class DailyEntry extends StatefulWidget {
  const DailyEntry({Key? key, required this.inputPost}) : super(key: key);

  final Post? inputPost;

  @override
  _DailyEntryState createState() => _DailyEntryState();
}

class _DailyEntryState extends State<DailyEntry> {
  late TextEditingController _controller;
  late Post post;
  late double _currentHappinessValue = 50;
  late bool _impactful = false;

  @override
  void didUpdateWidget(covariant DailyEntry oldWidget) {
    setState(() {
      _impactful = post.impactful;
      _currentHappinessValue = post.rating;
      _controller.text = post.entry;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.inputPost != null) {
      post = widget.inputPost!;
    }
    _controller = TextEditingController();
    loadUserSettings().then((void v) {
      if (widget.inputPost == null) {
        _controller.text = currentUserSettings.dailyEntryTemplate;
      }
    });

    DateTime convertedDate;

    if (widget.inputPost != null) {
      convertedDate = new DateTime(widget.inputPost!.date.year,
          widget.inputPost!.date.month, widget.inputPost!.date.day);
      post = widget.inputPost!;
      setState(() {
        _impactful = post.impactful;
        _currentHappinessValue = post.rating;
        _controller.text = post.entry;
      });
    } else {
      convertedDate = convertedCurrentDate;
      // Get the current day entry from firebase
      FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('date', isEqualTo: convertedDate)
          .withConverter<Post>(
            fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
            toFirestore: (post, _) => post.toJson(),
          )
          .limit(1)
          .get()
          .then((var snapshot) {
        if (snapshot.docs.isNotEmpty && snapshot.size > 0) {
          // if an an entry already exists then update the values
          setState(() {
            post = snapshot.docs.first.data();
            _impactful = post.impactful;
            _currentHappinessValue = post.rating;
            _controller.text = post.entry;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _currentDay() => Center(
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
                      dateFormat.format(widget.inputPost?.date ?? currentDate) +
                          '   -   Day #' +
                          daysAlive.toString(),
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
                            children: [Text("Rating")],
                          ),
                          Row(
                            children: [
                              Slider(
                                value: _currentHappinessValue,
                                label:
                                    numberFormat.format(_currentHappinessValue),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentHappinessValue = value;
                                  });
                                },
                              ),
                            ],
                          )
                        ]),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [Text("Impactful")],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                child: Icon(
                                  _impactful ? Icons.star : Icons.star_border,
                                  color: _impactful ? Colors.yellow : null,
                                ),
                                onTap: () {
                                  setState(() {
                                    _impactful = !_impactful;
                                    var impactfulText = _impactful
                                        ? "impactful, CONGRATS!"
                                        : "not impactful";

                                    ShowSnackBar.normal(context,
                                        "Day marked as $impactfulText");
                                    FocusScope.of(context).nextFocus();
                                  });
                                })
                          ],
                        )
                      ],
                    )
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
                      labelText: "How was your day?",
                      labelStyle: TextStyle(fontSize: 16),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            var text = _controller.text;

                            ShowSnackBar.normal(
                                context, "Updated entry for day #$daysAlive.");
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
                                          await DailyEntryModel().addEntry(
                                              appState.loginState,
                                              _controller.text,
                                              _currentHappinessValue,
                                              _impactful,
                                              widget.inputPost?.date ??
                                                  currentDate);
                                          Navigator.pop(context);
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
        body: _currentDay(),
        appBar: buildAppBar("Daily Entry"),
        bottomNavigationBar: Container(child: AdaptiveBannerAd()),
      ),
    );
  }
}
