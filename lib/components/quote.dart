import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getQuote(),
        builder: (context, AsyncSnapshot<DailyQuote> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Center(
                  child: Text(
                  snapshot.data != null
                      ? "${snapshot.data!.quote} \r\n\r\n"
                          "     -${snapshot.data!.author}"
                      : "",
                  textAlign: TextAlign.center,
                ))
              : Center(child: CircularProgressIndicator());
        });
  }
}

/// Quote kindly supplied by https://theysaidso.com/api/
Future<DailyQuote> _getQuote() async {
  DailyQuote quote;
  DailyQuote defaultQuote = DailyQuote(
      quote: "Thanks for using my app.", author: "Paul", date: DateTime.now());

  DocumentSnapshot<DailyQuote> _dbQuote = await FirebaseFirestore.instance
      .collection('globals')
      .doc('dailyQuote')
      .withConverter<DailyQuote>(
        fromFirestore: (snapshots, _) => DailyQuote.fromJson(snapshots.data()!),
        toFirestore: (quote, _) => quote.toJson(),
      )
      .get();

  quote = _dbQuote.data() ?? defaultQuote;
  if (quote.date.difference(DateTime.now()).inDays.abs() >= 1) {
// Update firebase with the new quote from the api
    final res = await http.get(Uri.parse('http://quotes.rest/qod.json'));
    if (res.statusCode == 200) {
      var data = await json.decode(res.body)['contents']['quotes'][0];
      quote = DailyQuote(
          quote: data['quote'], author: data['author'], date: DateTime.now());
      await FirebaseFirestore.instance
          .doc('globals/dailyQuote')
          .update(<String, dynamic>{
        'quote': data['quote'],
        'author': data['author'],
        'date': DateTime.now()
      });
    }
  }

  return quote;
}

class DailyQuote {
  final String quote;
  final String author;
  final DateTime date;

  DailyQuote({required this.quote, required this.author, required this.date});

  DailyQuote.fromJson(Map<String, Object?> json)
      : this(
          author: json['author'] as String,
          quote: json['quote'] as String,
          date: (json['date']! as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      'author': author,
      'quote': quote,
      'date': date,
    };
  }
}
