/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';

import '../MainScreen_Model/app_constants.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: padding,
      child: const CircularProgressIndicator(),
    );
  }
}
