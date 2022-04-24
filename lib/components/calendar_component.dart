import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:life_calendar/components/post.dart';
import 'package:life_calendar/views/daily_entry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:life_calendar/components/app_bar.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalendarComponent extends StatefulWidget {
  @override
  _CalendarComponentState createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  late final ValueNotifier<List<Post>> _selectedEvents;
  var posts = LinkedHashMap<DateTime, Post>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Can be toggled on/off by long-pressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter<Post>(
          fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
          toFirestore: (post, _) => post.toJson(),
        )
        .get()
        .then((var snapshot) {
      if (snapshot.docs.isNotEmpty && snapshot.size > 0) {
        // if an an entry already exists then update the values
        setState(() {
          Map<DateTime, Post> postMap = Map.fromIterable(snapshot.docs,
              key: (item) => item.data().date, value: (item) => item.data());
          posts.addAll(postMap);
          _onDaySelected(DateTime.now(), DateTime.now());
        });
      }
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Post> _getEventsForDay(DateTime day) {
    // Implementation example
    List<Post> postList = <Post>[];
    if (posts[day] != null) {
      postList.add(posts[day]!);
    }
    return postList;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Post>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: RangeSelectionMode.disabled,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            locale: 'en_US',
            headerStyle: HeaderStyle(formatButtonVisible: false),
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(),
              markerDecoration: const BoxDecoration(
                color: Colors.tealAccent,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Post>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.length > 0) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DailyEntry(
                                          inputPost: value[index],
                                        ),
                                    settings: RouteSettings(
                                        arguments: value[index].date)),
                              );
                            },
                            title: Text('${value[index].entry}'),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DailyEntry(
                                inputPost: generatePostForFocusedDay(),
                              ),
                            ),
                          );
                        },
                        title: Center(child: Text('Tap to add an entry!')),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
      appBar: buildAppBar("Calendar"),
    );
  }

  Post generatePostForFocusedDay() {
    DateTime postDate =
        new DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);

    return new Post(
      date: postDate,
      dateMS: postDate.millisecondsSinceEpoch,
      entry: currentUserSettings.dailyEntryTemplate,
      impactful: false,
      rating: 50.0,
      userId: currentUserSettings.userId,
    );
  }
}
