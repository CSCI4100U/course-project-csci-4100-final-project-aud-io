/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import 'auth_page.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              return MyHomePage(title: logo);
            } else {
              return AuthPage(title: logo);
            }

          },
        )
    );
  }
}