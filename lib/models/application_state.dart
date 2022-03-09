import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:life_calendar/services/authentication.dart';

class ApplicationState extends ChangeNotifier {

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        // _loginState = ApplicationLoginState.loggedOut;
        _loginState = ApplicationLoginState.emailAddress;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      // String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // TODO: move this somewhere else
  Future<void> addEntry(String message, double happiness, bool impactful,
      DateTime? dateTime) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    double oldRating = 50;

    var entryDate = dateTime ?? DateTime.now().toLocal();

    // Strip everything but the date since we only have 1 entry per day
    DateTime convertedDate = new DateTime(entryDate.year, entryDate.month, entryDate.day);

    var post = await FirebaseFirestore.instance
        .collection('posts')
        .add(<String, dynamic>{
      'entry': message,
      'date': convertedDate,
      'dateMS': convertedDate.millisecondsSinceEpoch,
      'rating': happiness,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    // Get the current aggregates before adding the potential new entry
    var aggregatesMonth = await FirebaseFirestore.instance.collection('aggregatesMonth')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('month', isEqualTo: convertedDate.year.toString() + '-' + convertedDate.month.toString())
        .get();

    var aggregatesYear = await FirebaseFirestore.instance.collection('aggregatesYear')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('year', isEqualTo: convertedDate.year.toString())
        .get();

    // Get the rating document
    var rating = await FirebaseFirestore.instance.collection('ratings')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isEqualTo: convertedDate)
        .get();

    bool ratingExistedPreviously = false;

    // TODO: add a class for posts and refactor this
    // Similar to what is listed here: https://firebase.flutter.dev/docs/firestore/example
    if (rating.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('ratings')
          .add(<String, dynamic>{
        'postId': post.id,
        'date': convertedDate,
        'dateMS': convertedDate.millisecondsSinceEpoch,
        'rating': happiness,
        'impactful': impactful,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    } else {
      var oldRatingDoc = await FirebaseFirestore.instance
          .collection('ratings')
          .doc(rating.docs.first.id)
          .get();

      if (oldRatingDoc.exists) {
        oldRating = oldRatingDoc['rating'];
      }

      // Update the rating
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(rating.docs.first.id)
          .set(<String, dynamic>{
            'postId': post.id,
            'date': convertedDate,
            'dateMS': convertedDate.millisecondsSinceEpoch,
            'rating': happiness,
            'impactful': impactful,
            'userId': FirebaseAuth.instance.currentUser!.uid,
          });
      ratingExistedPreviously = true;
    }

    // Aggregates
    if (aggregatesMonth.docs.isEmpty) {
      // Add the default values
      await FirebaseFirestore.instance.collection('aggregatesMonth')
        .add(<String, dynamic>{
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'month': convertedDate.year.toString() + '-' + convertedDate.month.toString(),
          'numRatings': 1,
          'averageRating': happiness,
        });
    } else {
      // TODO: there's some duplicate code that could be extracted here
      // Calculate the new average
      var initialAverageRating = aggregatesMonth.docs.first['averageRating'];
      var initialNumRatings = aggregatesMonth.docs.first['numRatings'];
      var updatedAverageRating = initialAverageRating;
      var numRatings = initialNumRatings;

      if (ratingExistedPreviously) {
        // subtract original value then add new value to the average
        if (initialNumRatings > 1) {
          updatedAverageRating = (initialAverageRating * initialNumRatings - oldRating) / (initialNumRatings - 1);
          updatedAverageRating = updatedAverageRating + ((happiness - updatedAverageRating) / (initialNumRatings));
        } else {
          updatedAverageRating = happiness;
        }
      } else {
        // add the new value to the average
        updatedAverageRating = updatedAverageRating + ((happiness - updatedAverageRating) / (initialNumRatings + 1));
        numRatings++;
      }

      // update month aggregates
      await FirebaseFirestore.instance
        .collection('aggregatesMonth')
        .doc(aggregatesMonth.docs.first.id)
        .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'month': convertedDate.year.toString() + '-' + convertedDate.month.toString(),
        'averageRating': updatedAverageRating,
        'numRatings': numRatings,
      }, SetOptions(merge: true));
    }

    if (aggregatesYear.docs.isEmpty) {
      // Add new year aggregates
      await FirebaseFirestore.instance.collection('aggregatesYear')
          .add(<String, dynamic>{
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'year': convertedDate.year.toString(),
        'numRatings': 1,
        'averageRating': happiness,
      });
    } else {
      // TODO: there's some duplicate code that could be extracted here
      // Calculate the new average
      var initialAverageRating = aggregatesYear.docs.first['averageRating'];
      var initialNumRatings = aggregatesYear.docs.first['numRatings'];
      var updatedAverageRating = initialAverageRating;
      var numRatings = initialNumRatings;

      if (ratingExistedPreviously) {
        // subtract original value then add new value to the average
        if (initialNumRatings > 1) {
          updatedAverageRating = (initialAverageRating * initialNumRatings - oldRating) / (initialNumRatings - 1);
          updatedAverageRating = updatedAverageRating + ((happiness - updatedAverageRating) / (initialNumRatings));
        } else {
          updatedAverageRating = happiness;
        }
      } else {
        // add the new value to the average
        updatedAverageRating = updatedAverageRating + ((happiness - updatedAverageRating) / (initialNumRatings + 1));
        numRatings++;
      }

      // update year aggregates
      await FirebaseFirestore.instance
          .collection('aggregatesYear')
          .doc(aggregatesYear.docs.first.id)
          .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'year': convertedDate.year.toString(),
        'averageRating': updatedAverageRating,
        'numRatings': numRatings,
      }, SetOptions(merge: true));
    }
  }
}
