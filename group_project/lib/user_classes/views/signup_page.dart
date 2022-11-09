import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:group_project/user_classes/views/utils.dart';

import '../../main.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.onClickedSignIn}) : super(key: key);

  final Function() onClickedSignIn;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Image(image: AssetImage('lib/images/audio_no_bg.png')),
        SizedBox(height:20,),
        TextFormField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: "Email", icon: Icon(Icons.email)),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) =>
              email != null && !EmailValidator.validate(email)
                  ? 'Please enter a valid email'
                  : null,
        ),
        SizedBox(height: 4,),
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration( icon: Icon(Icons.password), labelText: "Password"),
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value != null && value.length < 8
              ? 'Enter a valid password, required 8+ characters'
              : null,
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            onPressed: signUp,
            icon: Icon(Icons.arrow_forward, size: 32),
            label: Text(
              'Sign-Up',
              style: TextStyle(fontSize: 24),
            )
        ),
        SizedBox(height: 24,),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                text: 'Have An Account Already?   ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In HERE',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                  )
                ]
            )
        ),
      ],
      )
    );
  }

  Future signUp() async{

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

