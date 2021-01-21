import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/auth.dart';
import 'package:firebase_tutorials/home.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User _user = _firebaseAuth.currentUser;
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      body: user != null
          ? HomePage(
              user: user,
            )
          : AuthScreen(),
    );
  }
}
