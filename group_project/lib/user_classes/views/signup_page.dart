/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Views/custom_circular_progress_indicator.dart';
import 'package:group_project/user_classes/models/profile.dart';
import 'package:group_project/user_classes/models/utils.dart';
import '../../mainScreen_classes/MainScreen_Model/app_constants.dart';
import '../../main.dart';
import '../../statistics_classes/models/countries.dart';
import '../models/user_model.dart';

/*
* Class designated to load and receive input from the user
* during the signup process. With valid information, the user then
* is signed up into our applications database.
* */
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
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "titles.signup")),
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
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 2){
                  print('Swapping to French');
                  Locale newLocale = french;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 3) {
                  print('Swapping to Spanish');
                  Locale newLocale = spanish;
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });                }
              },
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: style,
                      controller: emailController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: FlutterI18n.translate(context, "forms.email"),
                          icon: const Icon(Icons.email)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? FlutterI18n.translate(context, "forms.errors.valid_email")
                          : null,
                    ),
                    const SizedBox(height: 14,),
                    TextFormField(
                      style: style,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.password),
                          labelText: FlutterI18n.translate(context, "forms.password")),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
                          ? FlutterI18n.translate(context, "forms.errors.valid_password")
                          : null,
                    ),
                    const SizedBox(height: 14,),
                    TextFormField(
                        style: style,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, "forms.username"),
                            icon: const Icon(Icons.person_pin)),
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return FlutterI18n.translate(context, "forms.errors.valid_user");
                          } else {
                            username = value;
                            return null;
                          }
                        }
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      style: style,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: FlutterI18n.translate(context, "forms.phone"),
                          icon: const Icon(Icons.phone)),
                      validator: (value){
                        if (value == null || value?.length != 10){
                          return FlutterI18n.translate(context, "forms.errors.valid_num");
                        } else {
                          phoneNum = value;
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                        style: style,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.location_city),
                            labelText: FlutterI18n.translate(context, "forms.city")),
                        validator: (value) {
                          if (value == null || value.length < 2) {
                            return FlutterI18n.translate(context, "forms.errors.valid_city");
                          } else {
                            city = value;
                            return null;
                          }
                        }
                    ),
                    const SizedBox(height: 14,),
                    DropdownButtonFormField(
                        style: const TextStyle(fontSize: fontSize, color: Colors.black),
                        decoration: InputDecoration(
                            labelText: FlutterI18n.translate(context, "forms.country"),
                            icon: const Icon(Icons.location_on)),
                        items: countriesForm
                            .map<DropdownMenuItem>((String value){
                              return DropdownMenuItem(
                                value: value,
                                  child: Text(value),
                              );
                        }).toList(),
                        isExpanded: true,
                        onChanged: (value) {
                          print("Country: $value");
                        },
                        validator: (value){
                          if (value == null) {
                            return FlutterI18n.translate(context, "forms.errors.valid_country");
                          } else {
                            country = value.toString();
                            return null;
                          }
                        }
                    ),
                    const SizedBox(height: 14),
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
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            FlutterI18n.translate(context, "forms.buttons.birthday"),
                            style: style,
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(_toDateString(_eventTime), style: style,)
                        )
                      ],
                    ),
                    const SizedBox(height: 14,),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                        ),
                        onPressed: signUp,
                        icon: const Icon(Icons.arrow_forward, size: 20),
                        label: Text(
                          FlutterI18n.translate(context, "titles.signup"),
                          style: style,
                        )
                    ),
                    const SizedBox(height: 14,),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(color: Colors.deepPurple, fontSize: fontSize),
                            text: FlutterI18n.translate(context, "forms.texts.have_account"),
                            children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickedSignIn,
                                  text: FlutterI18n.translate(context, "forms.buttons.login_here"),
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
          ],
        ),
      )
    );
  }

  /*
  * Function which occurs asynchronously to validate the registration
  * of a new user.
  * */
  Future signUp() async{

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CustomCircularProgressIndicator(),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, Colors.red);
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

    navigatorKey.currentState!.pop();
  }
}

/*
  * Function which returns a String value, used to format dates properly
  * */
String _twoDigits(int value){
  if (value > 9){
    return "$value";
  }
  return "0$value";
}

/*
  * Function which returns a string value, used to display dates properly
  * */
String _toDateString(DateTime date){
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

