import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:life_calendar/components/app_bar.dart';
import 'package:life_calendar/components/app_drawer.dart';
import 'package:life_calendar/components/globals.dart';
import 'package:life_calendar/components/snackbar.dart';
import 'package:life_calendar/models/application_state.dart';

import '../main.dart';

class UserSettings {
  UserSettings({
    required this.dailyEntryTemplate,
    required this.birthday,
    required this.inAppInfoMessagesPaused,
    required this.lifespanYears,
    required this.userId,
  });
  String dailyEntryTemplate;
  DateTime birthday;
  int lifespanYears;
  bool inAppInfoMessagesPaused;
  String userId;
}

void addDefaultSettings() async {
  var settings = FirebaseFirestore.instance.collection('settings');
  var userSettings = await settings
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  if (userSettings.docs.isEmpty) {
    currentUserSettings = defaultUserSettings;
    currentUserSettings.userId = FirebaseAuth.instance.currentUser!.uid;
    settings.add({
      'userId': currentUserSettings.userId,
      'dailyEntryTemplate': currentUserSettings.dailyEntryTemplate,
      'birthday': currentUserSettings.birthday,
      'lifespanYears': currentUserSettings.lifespanYears,
      'inAppInfoMessagesPaused': currentUserSettings.inAppInfoMessagesPaused,
    });
  }
}

Future<void> loadUserSettings() async {
  var _userSettings = await FirebaseFirestore.instance
      .collection('settings')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

  if (_userSettings.docs.isEmpty) {
    addDefaultSettings();
    return;
  }

  var userSettingsDoc = _userSettings.docs.first;
  currentUserSettings.dailyEntryTemplate =
      userSettingsDoc.get('dailyEntryTemplate');
  currentUserSettings.lifespanYears = userSettingsDoc.get('lifespanYears');
  currentUserSettings.birthday = new DateTime.fromMillisecondsSinceEpoch(
      userSettingsDoc.get('birthday').millisecondsSinceEpoch);
  currentUserSettings.inAppInfoMessagesPaused =
      userSettingsDoc.get('inAppInfoMessagesPaused');
  currentUserSettings.userId = userSettingsDoc.get('userId');
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController _maxAgeController;
  late TextEditingController _dailyEntryTemplateController;
  late var _userSettings;

  Future<void> updateSetting(String settingName, dynamic newValue) async {
    _userSettings = await FirebaseFirestore.instance
        .collection('settings')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (_userSettings.docs.isEmpty) {
      addDefaultSettings();
    }

    await FirebaseFirestore.instance
        .collection('settings')
        .doc(_userSettings.docs.first.id)
        .set({settingName: newValue}, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();

    _dailyEntryTemplateController = TextEditingController();
    _maxAgeController = TextEditingController();

    loadUserSettings().then((void v) {
      _dailyEntryTemplateController.text =
          currentUserSettings.dailyEntryTemplate;
      _maxAgeController.text = currentUserSettings.lifespanYears.toString();
    });
  }

  @override
  void dispose() {
    _maxAgeController.dispose();
    _dailyEntryTemplateController.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentUserSettings.birthday,
      firstDate: DateTime(currentDate.year - 120),
      lastDate: DateTime(currentDate.year),
    );
    if (picked != null && picked != currentUserSettings.birthday) {
      await updateSetting('birthday', picked);
      setState(() {
        var formattedDate = dateFormatDate.format(picked);
        ShowSnackBar.normal(context, "Birthday update to $formattedDate");
        FocusScope.of(context).nextFocus();
        currentUserSettings.birthday = picked;
      });
    }
  }

  Widget _build() => Center(
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.9,
            alignment: FractionalOffset.center,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Configuration",
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50, bottom: 0)),
                  ],
                ),
                SizedBox(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  width: 300,
                  height: 250,
                  child: TextField(
                    controller: _dailyEntryTemplateController,
                    maxLength: 1000,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Daily Entry Template",
                      labelStyle: TextStyle(fontSize: 16),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          var text = _dailyEntryTemplateController.text;
                          currentUserSettings.dailyEntryTemplate = text;
                          await updateSetting('dailyEntryTemplate', text);
                          setState(() {
                            ShowSnackBar.normal(
                                context, "Updated Daily Entry Template.");
                            FocusScope.of(context).nextFocus();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Birthday: " + dateFormatDate.format(birthday),
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text("Change"))
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _maxAgeController,
                            maxLength: 3,
                            maxLines: 1,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: "Max Age (Years)",
                              labelStyle: TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  var text = _maxAgeController.text;
                                  var inputNum = int.tryParse(text);
                                  if (inputNum != null)
                                    currentUserSettings.lifespanYears =
                                        inputNum;
                                  await updateSetting(
                                      'lifespanYears', inputNum);
                                  setState(() {
                                    ShowSnackBar.normal(
                                        context, "Updated max age to $text");
                                    FocusScope.of(context).nextFocus();
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: CheckboxListTile(
                        value: inAppInfoMessagesPaused,
                        title: Text("pause info messages"),
                        onChanged: (bool? value) async {
                          inAppInfoMessagesPaused = value!;
                          await updateSetting('inAppInfoMessagesPaused',
                              inAppInfoMessagesPaused);
                          setState(() {
                            // TODO: Firestore
                            ShowSnackBar.normal(
                                context,
                                inAppInfoMessagesPaused
                                    ? "Paused"
                                    : "Unpaused" + " info messages");
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Theme", style: TextStyle(fontSize: 24)),
                    Padding(padding: EdgeInsets.only(top: 50, bottom: 0)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 300, child: Text("Colors N Stuff")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Account", style: TextStyle(fontSize: 24)),
                    Padding(padding: EdgeInsets.only(top: 50, bottom: 0)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ApplicationState>().signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthWrapper()),
                            );
                          },
                          child: Text("Sign Out"),
                        )),
                  ],
                ),
              ],
            ))),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _build(),
      appBar: buildAppBar("Settings"),
      // drawer: buildDrawer(context),
    );
  }
}
