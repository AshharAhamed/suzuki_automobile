/* This is an service class  for work with the firebase authentication service.
*  This class will perform login, logout, register, such kind of user module tsk
*  This class is essential for login page and BaseScreen. */

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*abstract class for implement Authentication class*/
abstract class Authentication {
  Future<String> register(String email, String password);

  Future<String> login(String email, String password);

  Future<void> Logout();

  Future<FirebaseUser> getLogedInUser();


  Future<GoogleSignInAccount> getLogedInAccount(GoogleSignIn googleSignIn);

  Future<FirebaseUser> loginToFirebase(GoogleSignInAccount googleSignInAccount);
}

/*Authentication class for work with firebase authentication feature implementation of abstract class authentication*/
class AuthenticationImpl implements Authentication {
  final FirebaseAuth _authentication = FirebaseAuth.instance;

  /* login function to verify the login was successful or not*/
  @override
  Future<String> login(String email, String password) async {
    AuthResult result = await _authentication.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  /* egistration function to register an user by email and password*/
  @override
  Future<String> register(String email, String password) async {
    AuthResult result = await _authentication.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  /* Get current user function of application*/
  @override
  Future<FirebaseUser> getLogedInUser() async {
    FirebaseUser user = await _authentication.currentUser();
    return user;
  }

  /* Logout function*/
  @override
  Future<void> Logout() async {
    return _authentication.signOut();
  }

  @override
  Future<GoogleSignInAccount> getLogedInAccount(
      GoogleSignIn googleSignIn) async {
    // TODO: implement getSignedInAccount
    GoogleSignInAccount account = googleSignIn.currentUser;

    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  @override
  Future<FirebaseUser> loginToFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    // TODO: implement signIntoFirebase
//    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    print(googleAuth.accessToken);

    return null;
  }
}
