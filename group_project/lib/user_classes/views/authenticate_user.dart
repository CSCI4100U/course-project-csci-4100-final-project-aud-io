/*
* Author: Matthew Sharp
* */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:group_project/user_classes/models/utils.dart';
import '../../main.dart';
import '../models/notifications.dart';
import 'forgot_password.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key, required this.title, required this.onClickedSignUp}) : super(key: key);

  final VoidCallback onClickedSignUp;

  final Widget title;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _notifications = Notifications();


  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    _notifications.init();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(image: AssetImage('lib/images/audio_no_bg.png')),
        SizedBox(height:20,),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: "Email", icon: Icon(Icons.email)),
        ),
        SizedBox(height: 4,),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration( icon: Icon(Icons.password), labelText: "Password"),
          obscureText: true,
        ),
        SizedBox(height: 4,),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            onPressed: signIn,
            icon: Icon(Icons.lock_open, size: 32),
            label: Text(
              'Sign-in',
              style: TextStyle(fontSize: 24),
            )
        ),
        SizedBox(height: 14,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              child: Text(
                ' Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              onTap: (){
                _notifications.sendNotificationNow("Aud.io - Password Reset", "Please Fill in the Form to Reset Your Password");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ForgotPassword(),
                    )
                  );
              },
            ),
          ],
        ),
        SizedBox(height: 14,),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                text: 'Not Yet Signed Up?   ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign Up HERE',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                  )
                ]
            )
        ),
      ],
    );
  }

  Future signIn() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }
}