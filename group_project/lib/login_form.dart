import 'package:flutter/material.dart';

import 'main.dart';


class LoginForm extends StatefulWidget {
  LoginForm({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final formKey = GlobalKey<FormState>();
  TextStyle style =  TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: widget.title
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              style: TextStyle(fontSize: 30),
              decoration: const InputDecoration(
                label: Text("E-mail"),
                hintText: "Someone@email.com"
              ),
              validator: (value){
                print("Validating email: $value");
                if (value!.isEmpty){
                  return "Email must not be empty";
                }
                return null;
              },
              onSaved: (value){
                print("Saving email $value");
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 30),
              obscureText: true,
              decoration: const InputDecoration(
              label: Text("Password"),
              ),
              validator: (value){
                print("Validating password: $value");
              if (value!.length<7) {
                return "Password length too short, 8+ Chars";
                }
              return null;
              },
              onSaved: (value){
                print("Saving Password $value");
                },
            ),
            SizedBox(height: 10,),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        const SnackBar(
                          content: Text("Registration Successful"),
                        );
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(title: logo)));
                      },
                      child: Text("Login", style: style)
                  ),
                  ElevatedButton(
                      onPressed: (){
                        print("Sign Up Pressed");
                      },
                      child: Text("Sign Up", style: style)
                  ),
                  ElevatedButton(
                      onPressed: (){
                        print("Sending Password Reset Notification");
                      },
                      child: Text("Forgot Password", style: style)
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
