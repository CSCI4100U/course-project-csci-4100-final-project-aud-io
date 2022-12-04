import 'package:firebase_auth/firebase_auth.dart';
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
      body: ListView(
        children: [
           ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/statistics");
              },
              child: Text("Statistics", style: TextStyle(fontSize: 30))
           ),
          TextButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontSize: 30),
            ),
          )
         ],
      ),
    );
  }
}
