/*
* Author: Matthew Sharp
* */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'dart:async';
import 'package:group_project/user_classes/models/utils.dart';
import '../../main.dart';
import '../models/notifications.dart';
import '../models/user_model.dart';
import 'auth_page.dart';
import 'forgot_password.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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
  var when;
  Locale sharedLocale = Locale('en');

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    tz.initializeTimeZones();
    _notifications.init();

    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "titles.signin")),
        actions: [
          SizedBox(
            width: 37,
            child: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 1,
                    child: Text('Change to EN')
                ),
                const PopupMenuItem(
                    value: 2,
                    child: Text('Change to FR')
                ),
                const PopupMenuItem(
                    value: 3,
                    child: Text('Change to ES')
                ),
              ],
              onSelected: (value) {
                if (value == 1){
                  print('Swapping to English');
                  Locale newLocale = Locale('en');
                  sharedLocale = newLocale;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 2){
                  print('Swapping to French');
                  Locale newLocale = Locale('fr');
                  sharedLocale = newLocale;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 3) {
                  print('Swapping to Spanish');
                  Locale newLocale = Locale('es');
                  sharedLocale = newLocale;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Image(image: AssetImage('lib/images/audio_no_bg.png')),
            SizedBox(height:20,),
            TextField(
              style: TextStyle(fontSize: 20),
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, "forms.email"),
                  icon: Icon(Icons.email)
              ),
            ),
            SizedBox(height: 14,),
            TextField(
              style: TextStyle(fontSize: 20),
              controller: passwordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: FlutterI18n.translate(context, "forms.password")),
              obscureText: true,
            ),
            SizedBox(height: 14,),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: signIn,
                icon: Icon(Icons.lock_open, size: 20),
                label: Text(
                  FlutterI18n.translate(context, "titles.signin"),
                  style: TextStyle(fontSize: 20),
                )
            ),
            SizedBox(height: 14,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    FlutterI18n.translate(context, "forms.buttons.forgot"),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20
                    ),
                  ),
                  onTap: (){
                    _notifications.sendNotificationNow("Aud.io - Password Reset", "Please Fill in the Form to Reset Your Password");
                    when = tz.TZDateTime.now(tz.local).add(Duration(minutes: 2));
                    _notifications.scheduleNotificationLater(
                        "Aud.io - Password Reset",
                        "If you have not received an email, please resubmit the form",
                        when
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword(locale: sharedLocale),
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
                    text: FlutterI18n.translate(context, "forms.texts.no_account"),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          text: FlutterI18n.translate(context, "forms.buttons.signup_here"),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      )
                    ]
                )
            ),
          ],
        ),
      )
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
    await UserModel.initializeCurrentUser();
    navigatorKey.currentState!.pop();

  }
}