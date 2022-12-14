import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Model/navigation_bar.dart';

import '../MainScreen_Model/app_constants.dart';

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
      body: ListView(
        children: [
           Container(
             padding: padding,
             child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/statistics");
                },
                child: Text(FlutterI18n.translate(context, "forms.buttons.stats"), style: style)
             ),
           ),
          TextButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            child: Text(
              FlutterI18n.translate(context, "forms.buttons.logout"),
              style: style,
            ),
          )
         ],
      ),
    );
  }
}
