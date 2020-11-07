/*
* This is login page of application. which is providing simple login feature with firebase auth methode
* it has two functionality
*  if user of the application is have an account he/she can login
*  if does not have an account by click on create account switch the login form into registration form and can register email and password
* */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suzukiautomobile/api/UserAuthentication.dart';

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key key, this.title, this.authentication, this.loginCallback})
      : super(key: key);
  final Authentication authentication;
  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _logoAnimationConttroller;
  Animation<double> _logoAnimation;
  String _email;
  String _password;
  TextStyle style = TextStyle(fontSize: 25.0);
  final _fKey = new GlobalKey<FormState>();
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

//  initState function
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();

    _logoAnimationConttroller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));

    _logoAnimation = CurvedAnimation(
        parent: _logoAnimationConttroller, curve: Curves.bounceOut);

    _logoAnimation.addListener(() => this.setState(() {}));

    _logoAnimationConttroller.forward();
  }

//  reset the login form.
  void loginFormReset() {
    _fKey.currentState.reset();
    _errorMessage = "";
  }

//  Validate the login form fields.
//  and save input value for login form field to the variables.
  bool findValidateAndSave() {
    final form = _fKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /*togglr function for switch login form into registration*/
  void toggleForm() {
    loginFormReset();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  /* Login function to the application.
  *  if login success call loginCallBack*/
  void validateAndLogin() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (findValidateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.authentication.login(_email, _password);
          print('Signed In: $userId');
        } else {
          userId = await widget.authentication.register(_email, _password);
          print('Signed up user: $userId');
        }

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
//        Catching the Login Error
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _fKey.currentState.reset();
        });
      }
    }
  }

  /*  Widget function for Display the logo of the application in login form.*/
  Widget displayLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: Container(
            width: 135,
            height: 135,
            child: Image.asset("assets/images/suzuki_logo.png"),
          ),
        ),
        Text(
          "SUZUKI",
          style: new TextStyle(
              fontSize: 34.0, fontFamily: "Roboto", color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /*  Widget function for Display the pre loader or pregress loader of the application in login form.*/
  Widget displayCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  /*  Widget function for Display the login with facebook button for login by using facebook credential.*/
  Widget loginWithFacebookButton() {
    return new Container(
      margin: const EdgeInsets.only(top: 50),
      width: 340,
      child: RaisedButton(
        color: Colors.lightBlue,
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: Icon(
                FontAwesomeIcons.facebookF,
                size: 28,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text("Login With Facebook",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Roboto", color: Colors.white),
                  textAlign: TextAlign.justify),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(25, 13, 75, 13),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Colors.white70,
            )),
        disabledColor: Colors.indigoAccent,
        onPressed: () {},
      ),
    );
  }

  /*  Widget function for Display the login with facebook button for login by using google credential.*/
  Widget loginWithGoogleButton() {
    return new Container(
      margin: const EdgeInsets.only(top: 10),
      width: 340,
      child: RaisedButton(
        color: Color(0xFFEF7A85),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                FontAwesomeIcons.google,
                size: 28,
                color: Colors.white70,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text(
                "Login With Google",
                style: TextStyle(
                    fontSize: 20, fontFamily: "Roboto", color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(25, 13, 75, 13),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Colors.white70,
            )),
        disabledColor: Color(0xFFEF7A85), onPressed: () {},
//        onPressed: ,
      ),
    );
  }

  /* Seperator design for seperate the login with credential from login with email*/
  Widget separator() {
    return new Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 15),
              color: Colors.white70,
              height: 1.35,
              width: 120,
            )
          ]),
          Column(children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    "OR",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Roboto",
                        color: Colors.white70),
                  )
                ],
              ),
            )
          ]),
          Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 18),
              color: Colors.white70,
              height: 1.35,
              width: 120,
            )
          ]),
        ],
      ),
    );
  }

  /*Widget function for show Email Input Field as */
  Widget displayEmailInputField() {
    return new Container(
      child: new TextFormField(
        obscureText: false,
        enabled: true,
        style: TextStyle(fontSize: 17.0, color: Color(0xFFbdc6cf)),
//                    focusNode: FocusNode(canRequestFocus: false, skipTraversal: false),
        decoration: InputDecoration(
//                    icon: Icon(Icons.email),
          labelText: 'Email',
//                                fillColor: Colors.white,
//                                labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(FontAwesomeIcons.solidEnvelope),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(15)),
//                        disabledColor: Colors.white,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? 'Email Can\'t be empty' : null,
        onSaved: (value) => _email = value
            .trim(), /* Get user input value to the _email variable by onSaved method */
      ),
    );
  }

  /*Widget function for show Password Input Field as */
  Widget displayPasswordInputField() {
    return new Container(
      margin: const EdgeInsets.only(top: 10),
      width: 340,
      child: new TextFormField(
        obscureText: true,
        enabled: true,
        style: TextStyle(fontSize: 17.0, color: Color(0xFFbdc6cf)),
//                    focusNode: FocusNode(canRequestFocus: false, skipTraversal: false),
        decoration: new InputDecoration(
//                    icon: Icon(Icons.email),
          labelText: 'Password',
//                                  fillColor: Colors.white,
//                                  labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(FontAwesomeIcons.key),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? 'Password Can\'t be empty' : null,
        onSaved: (value) => _password = value
            .trim(), /* Get user input value to the _password variable by onSaved method */
      ),
    );
  }

  /* Widget function for Display the login Button.*/
  Widget displayLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        onPressed:
            validateAndLogin /*() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage()));
          }*/
        ,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEF7A85), Color(0xFFFFC2E2)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 340.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              _isLoginForm ? 'Login' : 'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
    /*return new Container(
      margin: const EdgeInsets.only(top: 15),
      child: RaisedButton(
        onPressed:validateAndLogin, // call Login function
        child: Text(
          _isLoginForm ? ' Login   ' : 'Register',
          style: TextStyle(
              fontSize: 20,
              fontFamily: "Roboto",
              color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(120, 13, 135, 13),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Colors.white70,
            )),
        disabledColor: Colors.lightBlue,
        color: Color(0xFFEF7A85),

      ),
    );*/
  }

  /* Widget function for Display the create account toggle Button.*/
  Widget displaySecondaryButton() {
    return Container(
      child: new FlatButton(
          child: new Text(
              _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.lightBlue,
              )),
          onPressed: toggleForm // Call toggle function
          ),
    );
  }

  /* Widget function for Display the login Error message from _errorMessage.*/
  Widget displayErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  /* build the login for scaffold*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_blured.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
//          fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  displayLogo(),
//                  loginWithFacebookButton(),
                  loginWithGoogleButton(),
                  separator(),
                  Container(
                      margin: const EdgeInsets.only(top: 17),
                      width: 340,
                      child: new Form(
                          key: _fKey,
                          child: Theme(
                            data: new ThemeData(
                                brightness: Brightness.dark,
                                primaryColor: Color(0xFFEF7A85),
                                primarySwatch: Colors.lime,
                                inputDecorationTheme: new InputDecorationTheme(
                                    labelStyle: new TextStyle(
                                        color: Color(0xFFEF7A85)))),
                            child: new Column(
                              children: <Widget>[
                                displayEmailInputField(),
                                displayPasswordInputField(),
                                displayLoginButton(),
                                displaySecondaryButton(),
                                displayErrorMessage(),
                              ],
                            ),
                          ))),
                  /*Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 340,
                    child: null
                  ),*/
//                  displayLoginButton(),
                  displayCircularProgress()
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
