import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/components/post.dart';
import 'package:life_calendar/components/post_item.dart';
import 'package:life_calendar/views/daily_entry.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'globals.dart';

class Entries7d extends StatefulWidget {
  const Entries7d({Key? key}) : super(key: key);

  @override
  _Entries7dState createState() => _Entries7dState();
}

class _Entries7dState extends State<Entries7d> {
// A reference to the list of posts.
// We are using `withConverter` to ensure that interactions with the collection
// are type-safe.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Post>>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .withConverter<Post>(
        fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
        toFirestore: (post, _) => post.toJson(),
      ).orderBy('dateMS', descending: true).snapshots(),
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
        if (data.size == 0) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.9,
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "There are no entries yet!",
                        style: TextStyle(fontSize: 24),
                      ),
                      // Padding(padding: EdgeInsets.only(top: 50, bottom: 0)),
                    ],
                  ),
                      SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DailyEntry()),
                              );
                            },
                            child: Text("Add Entry"),
                          )),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return PostItem(
              data.docs[index].data(),
              data.docs[index].reference,
            );
          },
        );
      },
    );
  }
}

