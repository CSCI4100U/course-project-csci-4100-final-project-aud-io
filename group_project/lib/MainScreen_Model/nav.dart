/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBarForSubPages(BuildContext context, String title){
  return AppBar(
    title: Text(title),
    actions: [
      IconButton(
          onPressed: (){
            //Call async function that goes to route "/home"
            Navigator.pushNamed(context, '/home');
          },
          tooltip: 'Home',
          icon: const Icon(Icons.home)
      ),
    ],
  );
}