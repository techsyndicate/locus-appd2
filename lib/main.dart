import 'package:flutter/material.dart';
import 'package:remedi/add.dart';
import 'package:remedi/notification_service.dart';
import 'package:remedi/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(ReMedi());
}

class ReMedi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReMedi',
      theme: ThemeData(fontFamily: "messinasans"),
      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        AddReminder.id: (context) => AddReminder()
      },
    );
  }
  
}
