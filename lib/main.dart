import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/screen/home_screen.dart';
import 'package:whatsapp_status/screen/live_statuses.dart';
import 'package:whatsapp_status/screen/saved_statuses.dart';
import 'package:whatsapp_status/styles/themes.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => FilesManager(), child: WAStatusApp()));
}

class WAStatusApp extends StatefulWidget {
  @override
  _WAStatusAppState createState() => _WAStatusAppState();
}

class _WAStatusAppState extends State<WAStatusApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        'live_stories': (context) => LiveStatusScreen(),
        'saved_stories': (context) => SavedStatusScreen()
      },
    );
  }
}
