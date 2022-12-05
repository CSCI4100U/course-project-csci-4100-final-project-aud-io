/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'signup_page.dart';
import '../../main.dart';
import 'authenticate_user.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(title: logo, onClickedSignUp: toggle,)
      : SignUpForm(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
