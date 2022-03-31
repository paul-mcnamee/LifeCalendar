import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/themes.dart';

import 'package:life_calendar/services/firebase_auth.dart';
import 'package:life_calendar/views/home.dart';
import 'package:life_calendar/services/authentication.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'models/application_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  runApp(ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => AuthService(FirebaseAuth.instance)),
          StreamProvider(create: (context) => context.read<AuthService>().authStateChanges,
              initialData: null)
        ],
        child: MaterialApp(
          title: 'Name Generator',
          theme: DefaultTheme().theme,
          home: AuthWrapper(),
        ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null)
      return Home();
    else
      return Scaffold(
          body: ListView(
            children: <Widget>[
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Authentication(
                  email: appState.email,
                  loginState: appState.loginState,
                  verifyEmail: appState.verifyEmail,
                  signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                  cancelRegistration: appState.cancelRegistration,
                  registerAccount: appState.registerAccount,
                  signOut: appState.signOut,
                ),
              ),
            ],
          )
      );
  }
}




