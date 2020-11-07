/*
* The BaseScreen class will decide the whether loading the mainScreen of login screen while start of the application.
* In here enum Authentication status class maintain three main authentication status of the application.
* according to the status base screen or root page will load the screens respectively.
* */

import 'package:flutter/material.dart';
import 'package:suzukiautomobile/api/UserAuthentication.dart';
import 'package:suzukiautomobile/screens/LoginPage.dart';
import 'package:suzukiautomobile/screens/MainHomePage.dart';

/*
* Base Screen Class
* */
class BaseScreen extends StatefulWidget {
  BaseScreen({this.auth});

  final Authentication
      auth; // create auth instance from BaseAuth abstract class  for get service feature from

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _BaseScreenState();
  }
}

/*
* Base Screen Status Class
* */
class _BaseScreenState extends State<BaseScreen> {
  AuthStatus authStatus = AuthStatus.NOT_IDENTIFIED;
  String _userId = "";

  //  initState function
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.auth.getLogedInUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

/*
* function for set the status in LOGGED_IN if authStatus is NOT_LOGGED_IN then login page will be open
* */
  void loginCallback() {
    widget.auth.getLogedInUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  /*
  * function for set the status in NOT_LOGGED_IN if authStatus is LOGGED_IN then home page will be open
  * */
  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  /*
  * Waiting status for NOT_IDENTIFIED.
  * */
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  /*
  * Build the component according to the its authStatus.
  * */
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus) {
      case AuthStatus.NOT_IDENTIFIED:
        return buildWaitingScreen();
        break;

      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          authentication: widget.auth,
          loginCallback: loginCallback,
        );
        break;

      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new MyHomePage(
            auth: widget.auth,
            logoutCallback: logoutCallback,
            userId: _userId,
          );
        } else
          return buildWaitingScreen();
        break;

      default:
        return buildWaitingScreen();
    }
  }
}

/*
* Global enum (flag) for set status of login page
* */
enum AuthStatus {
  NOT_IDENTIFIED, //while loading
  NOT_LOGGED_IN, //not loged in
  LOGGED_IN, //loged in
}
