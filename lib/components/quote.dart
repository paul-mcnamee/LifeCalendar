import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getQuote(),
        builder: (context, AsyncSnapshot<DailyQuote>snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Center(
              child: Text(
                snapshot.data != null
                    ? "${snapshot.data!.quote} \r\n"
                    "     -${snapshot.data!.author}"
                    : "Home",
                textAlign: TextAlign.center,
              ))
              : Center(child: CircularProgressIndicator());
        });
  }
}

/// Quote kindly supplied by https://theysaidso.com/api/
Future<DailyQuote> _getQuote() async {
  // TODO: uncomment for prod so we don't spam the quote api when testing...
  // final res = await http.get(Uri.parse('http://quotes.rest/qod.json'));
  // var data = await json.decode(res.body)['contents']['quotes'][0];
  // DailyQuote quote = DailyQuote(data['quote'], data['author']);
  DailyQuote quote = DailyQuote("Finish this app", "Paul");

  return quote;
}

class DailyQuote {
  late String quote;
  late String author;

  DailyQuote(quote, author) {
    this.author = author;
    this.quote = quote;
  }
}