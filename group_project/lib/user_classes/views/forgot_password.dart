/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../MainScreen_Views/custom_circular_progress_indicator.dart';
import '../models/notifications.dart';
import '../models/utils.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key, required this.locale}) : super(key: key);

  final Locale locale;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _notifications = Notifications();

  @override
  void dispost() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      FlutterI18n.refresh(context, widget.locale);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "titles.reset")),
      ),
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                FlutterI18n.translate(context, "forms.texts.enter_email"),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20,),
              TextFormField(
                style: TextStyle(fontSize: 20),
                controller: emailController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: FlutterI18n.translate(context, "forms.email"),
                    icon: Icon(Icons.email)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) {
                  email != null && !EmailValidator.validate(email)
                      ? 'Please Enter a Valid Email'
                      : null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: resetPassword,
                icon: Icon(Icons.send, size: 20,),
                label: Text(
                  FlutterI18n.translate(context, "titles.reset"),
                  style: TextStyle(fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              )
            ],
          )
        ),
      );
  }

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CustomCircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
      );
      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
