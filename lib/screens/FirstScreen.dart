import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolistapp/screens/LoginPage.dart';
import 'package:todolistapp/screens/SignupPage.dart';
import '../ExtractedData.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'todo',
            child: Lottie.network(
                'https://assets8.lottiefiles.com/packages/lf20_z4cshyhf.json'),
          ),
          LoginSingupButton(
            content: 'Login',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          SizedBox(
            height: 10,
          ),
          LoginSingupButton(
            content: 'Signup',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupPage()));
            },
          ),
        ],
      ),
    ));
  }
}
