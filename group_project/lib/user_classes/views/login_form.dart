/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import '../models/user_model.dart';
import 'auth_page.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              initializeCurrentUser();
              return MyHomePage(title: logo);
            } else {
              return AuthPage(title: logo);
            }

          },
        )
    );
  }

  initializeCurrentUser()async{
    await UserModel.initializeCurrentUser();
  }
}