/*
* Author: Rajiv Williams
* */

import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/nav.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: Column(
        children: [
          Text("No new notifications.", style: TextStyle(fontSize: 30),)
        ],
      ),
    );
  }
}
