/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBarForSubPages(BuildContext context, String title){
  return AppBar(
    title: Text(title),
  );
}