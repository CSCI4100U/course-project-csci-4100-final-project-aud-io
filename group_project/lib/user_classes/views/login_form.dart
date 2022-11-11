import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'auth_page.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              return MyHomePage(title: logo);
            } else {
              return AuthPage(title: logo);
            }

          },
        )
    );
  }
}











// class LoginForm extends StatefulWidget {
//   LoginForm({Key? key, required this.title}) : super(key: key);
//
//   final Widget title;
//
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<LoginForm> {
//
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   final formKey = GlobalKey<FormState>();
//   TextStyle style =  TextStyle(fontSize: 15);
//   var email = '';
//   var password = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           toolbarHeight: 100,
//           title: widget.title
//       ),
//       body: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               style: TextStyle(fontSize: 30),
//               decoration: const InputDecoration(
//                 label: Text("E-mail"),
//                 hintText: "Someone@email.com"
//               ),
//               validator: (value){
//                 print("Validating email: $value");
//                 if (value!.isEmpty){
//                   return "Email must not be empty";
//                 }
//                 email = value;
//                 return null;
//               },
//               onSaved: (value){
//                 print("Saving email $value");
//               },
//             ),
//             TextFormField(
//               style: TextStyle(fontSize: 30),
//               obscureText: true,
//               decoration: const InputDecoration(
//               label: Text("Password"),
//               ),
//               validator: (value){
//                 print("Validating password: $value");
//               if (value!.length<7) {
//                 return "Password length too short, 8+ Chars";
//               }
//               password = value;
//               return null;
//               },
//               onSaved: (value){
//                 print("Saving Password Successful");
//                 },
//             ),
//             SizedBox(height: 10,),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         print('Login button pressed');
//
//                         if (formKey.currentState!.validate()){
//                           print('Valid Input');
//                           formKey.currentState!.save();
//                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                             content: Text("Registration Successful"),
//                           ));
//                           users.add({'email' : email, 'password' : password}).then((value) => print('User Added')).catchError((error) => print('Failed to add user'));
//                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(title: logo)));
//
//                         } else{
//                           print("Validation Failed");
//                         }
//                       },
//                       child: Text("Login", style: style)
//                   ),
//                   ElevatedButton(
//                       onPressed: (){
//                         print("Sign Up Pressed");
//                       },
//                       child: Text("Sign Up", style: style)
//                   ),
//                   ElevatedButton(
//                       onPressed: (){
//                         print("Sending Password Reset Notification");
//                       },
//                       child: Text("Forgot Password", style: style)
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }