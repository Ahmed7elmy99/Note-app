import 'package:flutter/material.dart';

import 'package:glass_login/auth/screens/root.dart';
import 'package:glass_login/auth/screens/success.dart';
import 'package:glass_login/home.dart';
import 'package:glass_login/notes/add.dart';
import 'package:glass_login/notes/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';


late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      initialRoute: sharedPref.getString("id") == null ? "login" : "home",
      routes: {
        "login": (context) =>const AuthenticationScreen(),
        "home": (context) =>const Home(),
        "success": (context) => Success(controller: PageController()),
        "addnotes": (context) => AddNotes(),
        "editnotes": (context) => EditNotes(),
      },
    );
  }
}
