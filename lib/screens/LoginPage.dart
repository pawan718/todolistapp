import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolistapp/screens/HomePage.dart';
import '../ExtractedData.dart';
import '../models/AuthException_handler.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthExceptionHandler exceptionHandler = AuthExceptionHandler();
  String email = "";
  final _formKey = GlobalKey<FormState>();
  String password = "";
  String email2 = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'todo',
                child: Lottie.network(
                    'https://assets8.lottiefiles.com/packages/lf20_z4cshyhf.json'),
              ),
              EmailPasswordTextField(
                content: 'Enter Email',
                onPressed: (value) {
                  email = value;
                },
                obscuretext: false,
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
              ),
              SizedBox(
                height: 20,
              ),
              EmailPasswordTextField(
                  content: 'Password',
                  onPressed: (value) {
                    password = value;
                  },
                  obscuretext: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter email";
                    }
                  }),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Recover Password"),
                          actions: <Widget>[
                            EmailPasswordTextField(
                              obscuretext: false,
                              content: 'Enter email',
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
                                email2 = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: LoginSingupButton(
                                    content: 'Send',
                                    onPressed: () async {
                                      AuthStatus status = await exceptionHandler
                                          .resetPassword(email: email2);
                                      if (status == AuthStatus.successful) {
                                        Navigator.pop(context);
                                        const snackdemo = SnackBar(
                                          content:
                                              Text('Email sent successfully'),
                                          backgroundColor: Colors.green,
                                          elevation: 10,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(5),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackdemo);
                                      }
                                    })),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password ? ',
                      style: TextStyle(color: Colors.greenAccent),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              LoginSingupButton(
                content: 'Login',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final navigator = Navigator.of(context);
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      navigator.pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                      print("user2 ${_auth.currentUser}");
                    } catch (e) {
                      print(e);
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
