import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolistapp/models/CheckTask.dart';
import 'package:todolistapp/models/Task.dart';
import 'package:todolistapp/models/datamodel.dart';
import 'package:todolistapp/screens/AddTask.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolistapp/screens/FirstScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    TodosScreen(),
    const States(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: 'Todos',
            icon: Icon(Icons.list_rounded),
          ),
          BottomNavigationBarItem(
            label: 'states',
            icon: Icon(Icons.show_chart_rounded),
          ),
        ],
      ),
    );
  }
}

class TodosScreen extends StatefulWidget {
  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? userId;
  void getcurrentuser() {
    loggedInUser = _auth.currentUser;
    userId = _auth.currentUser!.uid!;
    print("user1 ${_auth.currentUser}");
    print(loggedInUser?.email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<CheckTaskCubit>().filter.name),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('show all'),
                onTap: () {
                  context.read<CheckTaskCubit>().setFilter(FilterData.all);
                },
              ),
              PopupMenuItem(
                child: const Text('show only completed'),
                onTap: () {
                  context
                      .read<CheckTaskCubit>()
                      .setFilter(FilterData.allCompleted);
                },
              ),
              PopupMenuItem(
                child: const Text('show only Active'),
                onTap: () {
                  context
                      .read<CheckTaskCubit>()
                      .setFilter(FilterData.allActive);
                },
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FirstScreen()));
                },
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Mark all completed'),
                onTap: () {
                  context.read<CheckTaskCubit>().setAllAsCompleted();
                },
              ),
              PopupMenuItem(
                child: const Text('Mark all uncompleted'),
                onTap: () {
                  context.read<CheckTaskCubit>().setAllAsActive();
                },
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.watch<CheckTaskCubit>().filter.name == "allCompleted"
            ? _firestore
                .collection('todolist')
                .where('user', isEqualTo: loggedInUser?.email)
                .where('taskstatus', isEqualTo: true)
                .snapshots()
            : context.watch<CheckTaskCubit>().filter.name == "allActive"
                ? _firestore
                    .collection('todolist')
                    .where('user', isEqualTo: loggedInUser?.email)
                    .where('taskstatus', isEqualTo: false)
                    .snapshots()
                : _firestore
                    .collection('todolist')
                    .where('user', isEqualTo: loggedInUser?.email)
                    .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final taskdata = snapshot.data?.docs;
          List<Task> alltasks = [];
          for (var tasks in taskdata!) {
            final currentUser = tasks['user'];
            if (currentUser != null || loggedInUser != null) {
              if (currentUser == loggedInUser?.email) {
                final text = tasks['tasktext'] ?? '';
                final id = tasks.id;
                final statusoftask = tasks['taskstatus'];
                final tasksdata =
                    Task(id: id, text: text, isCompleted: statusoftask);
                alltasks.add(tasksdata);
              }
            }
          }
          return SingleChildScrollView(
            child: Column(
                children: alltasks
                    .map((e) => ListTile(
                          title: Text(e.text),
                          leading: Checkbox(
                            value: e.isCompleted,
                            onChanged: (isChecked) {
                              print("check task ${e.isCompleted}");
                              if (e.isCompleted) {
                                context.read<CheckTaskCubit>().setActive(e.id);
                              } else {
                                context
                                    .read<CheckTaskCubit>()
                                    .setCompleted(e.id);
                              }
                            },
                          ),
                        ))
                    .toList()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<CheckTaskCubit>().setAllAsActive();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class States extends StatefulWidget {
  const States({Key? key}) : super(key: key);

  @override
  State<States> createState() => _StatesState();
}

class _StatesState extends State<States> {
  int? activetask = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      context.read<CountofCompletedTask>().getCompletedTasksCount();
      context.read<CountofPendinTask>().getCompletedTasksCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' Completed Todos ',
              style: TextStyle(fontSize: 20),
            ),
            BlocBuilder<CountofCompletedTask, int>(
              builder: (context, countofcompletedtask) => Text(
                "$countofcompletedtask",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            const Text(
              ' Active Todos',
              style: TextStyle(fontSize: 20),
            ),
            BlocBuilder<CountofPendinTask, int>(
                builder: (context, countofpedningtask) => Text(
                      "$countofpedningtask",
                      style: const TextStyle(fontSize: 15),
                    )),
          ],
        )),
      ),
    );
  }
}
//
// BlocBuilder<CheckTaskCubit, List<Task>>(
// builder: (context, tasks) => ListView.builder(
// physics: const BouncingScrollPhysics(),
// itemCount: tasks.length,
// itemBuilder: (context, index) {
// final ct = tasks[index];
// print(ct);
// return Dismissible(
// onDismissed: (direction) {
// Task copiedtask = ct;
// context.read<CheckTaskCubit>().removeTask(ct.id);
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text('task is  deleted'),
// action: SnackBarAction(
// label: 'undo',
// onPressed: () {
// context.read<CheckTaskCubit>().addTask(ct.text);
// },
// ),
// ),
// );
// },
// key: Key(ct.id),
// child: ListTile(
// leading: Checkbox(
// value: ct.isCompleted,
// onChanged: (isChecked) {
// if (isChecked == null) {
// return;
// }
// if (!isChecked) {
// context.read<CheckTaskCubit>().setActive(ct.id);
// } else {
// context.read<CheckTaskCubit>().setCompleted(ct.id);
// }
// }),
// title: Text(ct.text),
// ),
// );
// }),
// ),
