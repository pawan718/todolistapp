import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'Task.dart';

User? loggedInUser;

enum FilterData { allCompleted, allActive, all }

FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CountofCompletedTask extends Cubit<int> {
  int? activetask;
  CountofCompletedTask() : super(0);

  void getcurrentuser() {
    loggedInUser = _auth.currentUser;
  }

  void getCompletedTasksCount() async {
    getcurrentuser();
    activetask = await _firestore
        .collection('todolist')
        .where('user', isEqualTo: loggedInUser?.email)
        .where('taskstatus', isEqualTo: true)
        .get()
        .then((value) => value.size);
    emit(activetask!);
  }
}

class CountofPendinTask extends Cubit<int> {
  int? pedningTasks;
  CountofPendinTask() : super(0);

  void getcurrentuser() {
    loggedInUser = _auth.currentUser;
  }

  void getCompletedTasksCount() async {
    getcurrentuser();
    pedningTasks = await _firestore
        .collection('todolist')
        .where('user', isEqualTo: loggedInUser?.email)
        .where('taskstatus', isEqualTo: false)
        .get()
        .then((value) => value.size);
    emit(pedningTasks!);
  }
}

class CheckTaskCubit extends Cubit<List<Task>> {
  final Uuid uuid = const Uuid();
  CheckTaskCubit() : super([]);
  final List<Task> allTasks = [];
  FilterData filter = FilterData.all;

  void getcurrentuser() {
    loggedInUser = _auth.currentUser;
  }

  void setCompleted(String id) {
    _firestore.collection('todolist').doc(id).update({
      'taskstatus': true,
    });
  }

  Future<int> getPendingTasksCount() async {
    getcurrentuser();
    int data = await _firestore
        .collection('todolist')
        .where('user', isEqualTo: loggedInUser?.email)
        .where('taskstatus', isEqualTo: false)
        .get()
        .then((value) => value.size);
    print("task length is $data");
    return data;
  }

  void setActive(String id) {
    _firestore.collection('todolist').doc(id).update({
      'taskstatus': false,
    });
  }

  void setAllAsCompleted() {
    getcurrentuser();
    _firestore
        .collection('todolist')
        .where('user', isEqualTo: loggedInUser?.email)
        .get()
        .then((querysnapshot) => querysnapshot.docs.forEach((element) {
              element.reference.update({'taskstatus': true});
            }));
  }

  void setAllAsActive() {
    getcurrentuser();
    _firestore
        .collection('todolist')
        .where('user', isEqualTo: loggedInUser?.email)
        .get()
        .then((querysnapshot) => querysnapshot.docs.forEach((element) {
              element.reference.update({'taskstatus': false});
            }));
  }

  void removeTask(String taskId) {
    final index = allTasks.indexWhere((e) => e.id == taskId);
    allTasks.removeAt(index);
  }

  void updateFilteredList() {
    switch (filter) {
      case FilterData.all:
        emit([...allTasks]);
        break;
      case FilterData.allActive:
        emit(allTasks.where((element) => !element.isCompleted).toList());
        break;
      case FilterData.allCompleted:
        emit(allTasks.where((element) => element.isCompleted).toList());
        break;
    }
  }

  void setFilter(FilterData f) {
    filter = f;
    updateFilteredList();
  }
}
