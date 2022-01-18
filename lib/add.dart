import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:remedi/global/myDimens.dart';
import 'package:remedi/global/mySpaces.dart';
import 'package:remedi/welcome.dart';

Future<String> loadReminders() {
  return rootBundle.loadString('assets/reminders.json');
}

class AddReminder extends StatefulWidget {
  static String id = "addReminder";

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  TextEditingController medicineInput = TextEditingController();
  TextEditingController dosageInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  String frequency = '';
  DateTime reminderTime;

  @override
  void dispose() {
    medicineInput.dispose();
    dosageInput.dispose();
    timeInput.dispose();
    descriptionInput.dispose();
    super.dispose();
  }

  @override
  void initState() {
    timeInput.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(MyDimens.double_40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Add Reminder', style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold)),
            MySpaces.vGapInBetween,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Medicine Name', style: TextStyle(fontSize: 16.0)),
                MySpaces.vGapInBetween,
                TextField(
                  controller: medicineInput,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info, color: Colors.black),
                      hintText: 'Paracetamol',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                      fillColor: Color(0xFFF8F8F6),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16.0)
                  ),
                ),
              ],
            ),
            MySpaces.vSmallGapInBetween,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Dosage (in mg)', style: TextStyle(fontSize: 16.0)),
                MySpaces.vGapInBetween,
                TextField(
                  controller: dosageInput,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Tab(icon: Image.asset('assets/pill.png')),
                      hintText: '100',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                      fillColor: Color(0xFFF8F8F6),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16.0)
                  ),
                ),
              ],
            ),
            MySpaces.vSmallGapInBetween,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Time', style: TextStyle(fontSize: 16.0)),
                MySpaces.vGapInBetween,
                TextField(
                  controller: timeInput,
                  readOnly: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.watch_later_outlined, color: Colors.black),
                      hintText: '10:30 AM',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                      fillColor: Color(0xFFF8F8F6),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16.0)
                  ),
                  onTap: () async {
                    TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                    if (pickedTime != null) {
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      print(parsedTime);
                      String formattedTime = DateFormat('h:mm a').format(parsedTime);
                      setState(() {
                        timeInput.text = formattedTime;
                      });
                      reminderTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, parsedTime.hour, parsedTime.minute, parsedTime.second);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please choose a time.')));
                    }
                  },
                ),
              ],
            ),
            MySpaces.vSmallGapInBetween,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Frequency', style: TextStyle(fontSize: 16.0)),
                MySpaces.vGapInBetween,
                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        frequency = "Daily";
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      padding: EdgeInsets.all(14.0),
                      color: Color(0xFFF8F8F6),
                      child: Text('Daily', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    ),
                    MySpaces.hGapInBetween,
                    RaisedButton(
                      onPressed: () {
                        frequency = "Weekly";
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      padding: EdgeInsets.all(14.0),
                      color: Color(0xFFF8F8F6),
                      child: Text('Weekly', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    ),
                    MySpaces.hGapInBetween,
                    RaisedButton(
                      onPressed: () {
                        frequency = "Monthly";
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      padding: EdgeInsets.all(14.0),
                      color: Color(0xFFF8F8F6),
                      child: Text('Monthly', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    )
                  ],
                )
              ],
            ),
            MySpaces.vSmallGapInBetween,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Additional Description', style: TextStyle(fontSize: 16.0)),
                MySpaces.vGapInBetween,
                TextField(
                  controller: descriptionInput,
                  decoration: InputDecoration(
                      hintText: 'Take the dose twice per day. Don\'t forget!',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                      fillColor: Color(0xFFF8F8F6),
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16.0)
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            MySpaces.vSmallGapInBetween,
            FutureBuilder(
              future: loadReminders(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to locate database.')));
                }

                if (snapshot.hasData) {
                  List<dynamic> reminders = jsonDecode(snapshot.data.toString());

                  return RaisedButton(
                    onPressed: () async {
                      Map<String, dynamic> newReminder = {
                        "name": medicineInput.text,
                        "dosage": dosageInput.text,
                        "recurring": frequency,
                        "time": reminderTime.toString(),
                        "notes": descriptionInput.text
                      };
                      print(newReminder);
                      reminders.add(newReminder);

                      Directory directory = await getApplicationDocumentsDirectory();
                      print(directory.path);

                      final File jsonFile = File('${directory.path}/remindersdb.json');
                      await jsonFile.writeAsString(jsonEncode(reminders));

                      medicineInput.clear();
                      dosageInput.clear();
                      frequency = '';
                      timeInput.clear();
                      descriptionInput.clear();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added reminder successfully!')));
                      Navigator.pushNamed(context, Welcome.id);
                    },
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    padding: EdgeInsets.all(14.0),
                    color: Color(0xFF1B64D1),
                    child: Center(
                      child: Text('Done', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
