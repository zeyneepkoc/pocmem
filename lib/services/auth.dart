import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocmem/models/user.dart';
import 'package:pocmem/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn = false;
  bool isSignIn = false;

  UserModel? _currentUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_currentUser);
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      isLoggedIn = true;
      Navigator.pop(context);
      return user;
    } on FirebaseAuthException catch (e) {
      isLoggedIn = false;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(Map<String, dynamic> Info, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: Info["email"].toString(), password: Info["password"].toString());
      User? user = result.user;
      isSignIn = true;
      Database().createUser(user!.uid.toString(), Info);
      Navigator.pop(context);
      Navigator.pop(context);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      isSignIn = false;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
