import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/Controller/LoginController.dart';
import 'Controller/MainAppController.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            //On est auth
            return new MainAppController();
          } else {
            //On n'est pas Auth
            return new LoginController();
          }
        }
    );
  }
}
