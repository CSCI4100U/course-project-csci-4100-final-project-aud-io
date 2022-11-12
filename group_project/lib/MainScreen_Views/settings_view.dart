import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Model/nav.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title!),
      body: Column(
        children: [
          Text("This is our Project hope you enjoy!", style: TextStyle(fontSize: 30),)
        ],
      ),
    );
  }
}
