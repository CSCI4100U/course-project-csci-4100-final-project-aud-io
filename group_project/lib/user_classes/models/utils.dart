/*
* Author: Matthew Sharp
* */

import 'package:flutter/material.dart';

/*
  * Class which helps us with displaying the snackbars of a particular
  * page, whether it be success or error messages.
  * */
class Utils{
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, Color color){
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: color);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}