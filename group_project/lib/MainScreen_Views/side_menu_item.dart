import 'package:flutter/material.dart';
import 'main.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({Key? key,this.title,this.route}) : super(key: key);

  final String? title;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.deepPurple,
      child: TextButton(
        child: Text("$title",
          style: const TextStyle(
              color: Colors.white,
              fontSize: 30
          ),
        ),
        onPressed: (){
          //Call async function that goes to route (eg. "/routeName")
          Navigator.pushNamed(context, '$route');

          print("You pressed button $title!");
        },
      ),
    );

  }
}
