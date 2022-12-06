/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'signup_page.dart';
import '../../main.dart';
import 'authenticate_user.dart';

/*
  * Class which is used to swap between the login page and the sign up page.
  * Depending on the request of the user, this will either display the login
  * page or the sign up page. This will never overlap or display both. The
  * routing for this is found on the bottom right of the Login Screen
  * ("SignUp Here") and on the SignUp Screen ("Login Here")
  * */
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
