/*
* Author: Matthew Sharp
* */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Views/custom_circular_progress_indicator.dart';
import 'dart:async';
import 'package:group_project/user_classes/models/utils.dart';
import '../../mainScreen_classes/MainScreen_Model/app_constants.dart';
import '../../main.dart';
import '../models/notifications.dart';
import '../models/user_model.dart';
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
  Locale sharedLocale = english;

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
                PopupMenuItem(
                    value: 1,
                    child: Text(FlutterI18n.translate(context, "forms.languages.english"))
                ),
                PopupMenuItem(
                    value: 2,
                    child: Text(FlutterI18n.translate(context, "forms.languages.french"))
                ),
                PopupMenuItem(
                    value: 3,
                    child: Text(FlutterI18n.translate(context, "forms.languages.spanish"))
                ),
              ],
              onSelected: (value) {
                if (value == 1){
                  print('Swapping to English');
                  Locale newLocale = english;
                  sharedLocale = newLocale;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 2){
                  print('Swapping to French');
                  Locale newLocale = french;
                  sharedLocale = newLocale;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 3) {
                  print('Swapping to Spanish');
                  Locale newLocale = spanish;
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
            const SizedBox(height: 20,),
            const Image(image: AssetImage('lib/images/audio_no_bg.png')),
            const SizedBox(height:20,),
            TextField(
              style: style,
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, "forms.email"),
                  icon: const Icon(Icons.email)
              ),
            ),
            const SizedBox(height: 14,),
            TextField(
              style: style,
              controller: passwordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  icon: const Icon(Icons.password),
                  labelText: FlutterI18n.translate(context, "forms.password")),
              obscureText: true,
            ),
            const SizedBox(height: 14,),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: signIn,
                icon: const Icon(Icons.lock_open, size: 20),
                label: Text(
                  FlutterI18n.translate(context, "titles.signin"),
                  style: style,
                )
            ),
            const SizedBox(height: 14,),
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
                    _notifications.sendNotificationNow(
                        FlutterI18n.translate(context, "notifs.header"),
                        FlutterI18n.translate(context, "notifs.notif_now")
                    );
                    when = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));
                    _notifications.scheduleNotificationLater(
                        FlutterI18n.translate(context, "notifs.header"),
                        FlutterI18n.translate(context, "notifs.notif_later"),
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
            const SizedBox(height: 14,),
            RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.deepPurple, fontSize: fontSize),
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
        builder: (context) => const CustomCircularProgressIndicator(),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, Colors.red);
    }
    await UserModel.initializeCurrentUser();
    navigatorKey.currentState!.pop();

  }
}