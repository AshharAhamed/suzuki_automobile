/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This is the main application.  This file will execute when the application runs.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'package:suzukiautomobile/api/UserAuthentication.dart';
import 'package:suzukiautomobile/screens/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suzuki Automobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BaseScreen(
          auth:
              new AuthenticationImpl(),// Call the BaseScreen then root page will decide whether it need to redirect to the home page or login page
      ),
    );
  }
}
