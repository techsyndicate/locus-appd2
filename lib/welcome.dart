import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remedi/add.dart';
import 'package:remedi/global/myColors.dart';
import 'package:remedi/global/myDimens.dart';
import 'package:remedi/global/mySpaces.dart';
import 'package:remedi/notification_service.dart';

Future<String> loadReminders() async {
  Directory directory = await getApplicationDocumentsDirectory();
  final File jsonFile = File('${directory.path}/remindersdb.json');
  return await jsonFile.readAsString();
}

class Welcome extends StatefulWidget {
  static String id = "welcome";
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(MyDimens.double_40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                Text('Welcome back,', style: TextStyle(fontSize: 36.0)),
                Text('ikkumpal', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold))
              ],
            ),
            MySpaces.vMediumGapInBetween,
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search reminders...',
                hintStyle: TextStyle(color: Color(0xFF9B9B9B), fontSize: 20.0),
                fillColor: Color(0xFFF8F8F6),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(16.0)
              ),
            ),
            MySpaces.vMediumGapInBetween,
            Text('Current Reminders', style: TextStyle(fontSize: 24.0)),
            MySpaces.vGapInBetween,
            FutureBuilder(
              future: loadReminders(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Unable to fetch your reminders. Please try again.');
                }

                if (snapshot.hasData) {
                  List<dynamic> reminders = jsonDecode(snapshot.data.toString());

                  return Container(
                    height: 340.0,
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      shrinkWrap: true,
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFF8F8F6), width: 2.0),
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: InkWell(
                            onTap: () {
                              NotificationService().scheduleNotification(reminders[index]['name'], DateTime.parse(reminders[index]['time']));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set!')));
                            },
                            child: ListTile(
                              leading: Container(
                                  child: Tab(icon: Image.asset('assets/pill.png')),
                              ),
                              title: Text(reminders[index]['name'], style: TextStyle(fontSize: 20.0)),
                              subtitle: Text(DateFormat('h:mm a').format(reminders[index]['time']) + ' | ' + reminders[index]['recurring'], style: TextStyle(fontSize: 18.0))
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            MySpaces.vMediumGapInBetween,
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddReminder.id);
              },
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: EdgeInsets.all(14.0),
              color: Color(0xFF1B64D1),
              child: Center(
                child: Text(
                  'Add Reminder',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}