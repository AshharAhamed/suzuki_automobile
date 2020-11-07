/// CTSE Final Flutter Project - Suzuki Automobile
///
/// This contains the main home page of the application. Once the user successfully
/// logged in, user will navigated to the home screen. Where it contains the list
/// of the cars.
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'package:suzukiautomobile/api/UserAuthentication.dart';
import 'package:suzukiautomobile/screens/AddCarDetails.dart';
import 'package:suzukiautomobile/screens/CarPopularity.dart';
import 'package:suzukiautomobile/widgets/BaseAppBar.dart';
import 'package:suzukiautomobile/screens/MainList.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.logoutCallback, this.userId})
      : super(key: key);
  final String title;
  final Authentication auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Logout method
  logout() async {
    try {
      await widget.auth.Logout();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BaseAppBar(
          title: Text('Suzuki Automobiles'),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCarDetails()));
                },
              )
            ],
          ),
        ),
        //body: ListPage(),
        body: AutomobileList(),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset("assets/images/suzuki_logo.png"),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEF7A85), Color(0xFFFFC2E2)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              ListTile(
                title: Text('Manage Cars'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCarDetails()));
                },
              ),
              ListTile(
                title: Text('Car Popularity'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CarPopularity()));
                },
              ),
              ListTile(
                title: Text('About Us'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: logout,
              )
            ],
          ),
        ));
  }
}
