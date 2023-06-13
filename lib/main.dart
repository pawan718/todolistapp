import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolistapp/models/CheckTask.dart';
import 'package:todolistapp/screens/FirstScreen.dart';
import 'package:todolistapp/screens/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget CheckUser() {
    if (_auth.currentUser != null) {
      String? email = _auth.currentUser?.email;
      print(_auth.currentUser);
      SnackBar(
        content: Text(email!),
      );
      return HomePage();
    }
    return FirstScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CheckTaskCubit>(
          create: (BuildContext context) => CheckTaskCubit(),
        ),
        BlocProvider<CountofCompletedTask>(
          create: (BuildContext context) => CountofCompletedTask(),
        ),
        BlocProvider<CountofPendinTask>(
          create: (BuildContext context) => CountofPendinTask(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: CheckUser(),
      ),
    );
  }
}
