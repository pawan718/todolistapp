import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../models/CheckTask.dart';
import '../models/Task.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final Uuid uuid = const Uuid();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String textEnteredbyUser = "";
  User? loggedInUser;

  final _formKey = GlobalKey<FormState>();
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD Task'),
        leading: const Icon(Icons.arrow_back_ios_new_sharp),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "This field can't be empty";
              }
              return null;
            },
            onChanged: (value) {
              textEnteredbyUser = value;
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            Navigator.of(context).pop();
            _firestore.collection('todolist').add({
              'id': uuid.v4(),
              'tasktext': textEnteredbyUser,
              'taskstatus': false,
              'user': loggedInUser?.email
            });
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
