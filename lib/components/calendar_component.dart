import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/components/post.dart';
import 'package:life_calendar/views/daily_entry.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/app_drawer.dart';

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

  // Can be toggled on/off by longpressing a date
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

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
              key: (item) => item.data().date,
              value: (item) => item.data());
          posts.addAll(postMap);
        });
      }
    });

    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Post> _getEventsForDay(DateTime day) {
    // Implementation example
    List<Post> postList = <Post>[] ;
    if (posts[day] != null) {
      postList.add(posts[day]!);
    }
    return postList;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
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
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: RangeSelectionMode.disabled,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            locale: 'en_US',
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
                            MaterialPageRoute(builder: (context) => DailyEntry(inputPost: value[index],),
                                settings: RouteSettings(arguments: value[index].date)),
                          );
                        },
                        title: Text('${value[index].entry}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      appBar: buildAppBar("Calendar"),
      drawer: buildDrawer(context),
    );
  }
}