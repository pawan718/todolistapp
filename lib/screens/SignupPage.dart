import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolistapp/ExtractedData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolistapp/screens/HomePage.dart';

class SignupPage extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'todo',
                child: Lottie.network(
                    'https://assets8.lottiefiles.com/packages/lf20_z4cshyhf.json'),
              ),
              EmailPasswordTextField(
                content: 'Enter Email',
                validator: (value) {
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!);
                  print(emailValid);
                  if (value == null || value.isEmpty) {
                    return "email should not be empty";
                  }
                  if (!emailValid) {
                    return "email not valid";
                  }
                  return null;
                },
                onPressed: (value) {
                  email = value;
                },
                obscuretext: false,
              ),
              SizedBox(
                height: 20,
              ),
              EmailPasswordTextField(
                content: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter password";
                  }
                },
                onPressed: (value) {
                  password = value;
                },
                obscuretext: false,
              ),
              SizedBox(
                height: 20,
              ),
              LoginSingupButton(
                content: 'Signup',
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    UserCredential user =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    if (user != null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
