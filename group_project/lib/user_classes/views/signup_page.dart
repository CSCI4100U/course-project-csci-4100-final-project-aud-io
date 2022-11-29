/*
* Author: Matthew Sharp
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:group_project/user_classes/models/profile.dart';
import 'package:group_project/user_classes/models/utils.dart';
import '../../main.dart';
import '../models/user_model.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.onClickedSignIn}) : super(key: key);

  final Function() onClickedSignIn;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _eventTime = DateTime.now();
  final users = UserModel();
  var username = '';
  var phoneNum = '';
  var birthday = '';
  var city = '';
  var country = '';


  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime rightNow = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: "Email", icon: Icon(Icons.email)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Please enter a valid email'
                              : null,
                        ),
                        SizedBox(height: 4,),
                        TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration( icon: Icon(Icons.password), labelText: "Password"),
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value != null && value.length < 8
                              ? 'Enter a valid password, required 8+ characters'
                              : null,
                        ),
                        SizedBox(height: 4,),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(labelText: "Username", icon: Icon(Icons.person_pin)),
                            validator: (value) {
                              if (value == null || value.length < 4) {
                                return 'Enter a Valid UserName';
                              } else {
                                username = value;
                                return null;
                              }
                            }
                        ),
                        SizedBox(height: 4),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(labelText: "Phone Number (no spaces)", icon: Icon(Icons.phone)),
                          validator: (value){
                            if (value == null || value?.length != 10){
                              return 'Enter a Valid Phone Number';
                            } else {
                              phoneNum = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 4),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(icon: Icon(Icons.location_city), labelText: "City"),
                            validator: (value) {
                              if (value == null || value.length < 2) {
                                return 'Enter a Valid City Name';
                              } else {
                                city = value;
                                return null;
                              }
                            }
                        ),
                        SizedBox(height: 4,),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(labelText: "Country", icon: Icon(Icons.location_on)),
                            validator: (value) {
                              if (value == null || value.length < 2) {
                                return 'Enter a Valid Country Name';
                              } else {
                                country = value;
                                return null;
                              }
                            }
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: (){
                                showDatePicker(
                                    context: context,
                                    initialDate: rightNow,
                                    firstDate: DateTime(1900),
                                    lastDate: rightNow
                                ).then((value) {
                                  setState(() {
                                    _eventTime = DateTime(value!.year, value.month, value.day);
                                    birthday = _toDateString(_eventTime);
                                  });
                                });
                              },
                              icon: Icon(Icons.calendar_month),
                              label: Text('Birthday', style: TextStyle(fontSize: 20,),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(_toDateString(_eventTime), style: TextStyle(fontSize: 20),)
                            )
                          ],
                        ),
                        SizedBox(height: 4,),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                            ),
                            onPressed: signUp,
                            icon: Icon(Icons.arrow_forward, size: 32),
                            label: Text(
                              'Sign-Up',
                              style: TextStyle(fontSize: 24),
                            )
                        ),
                        SizedBox(height: 24,),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                                text: 'Have An Account Already?   ',
                                children: [
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = widget.onClickedSignIn,
                                      text: 'Log In HERE',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context).colorScheme.secondary,
                                      )
                                  )
                                ]
                            )
                        ),
                      ],
                    )
                )
            )
          ],
        ),
      );
  }

  Future signUp() async{

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    Profile newUser = Profile(
      email: emailController.text.toString(),
      userName: username,
      phoneNum: phoneNum,
      country: country,
      city: city,
      birthday: birthday
    );

    users.insertUser(newUser);

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

String _twoDigits(int value){
  if (value > 9){
    return "$value";
  }
  return "0$value";
}

String _toDateString(DateTime date){
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

