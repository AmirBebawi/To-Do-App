
import 'package:flutter/material.dart';
import 'package:todoapp/moduels/archived_tasks/archived_tasks.dart';
import 'package:todoapp/moduels/done_tasks/done_tasks.dart';
import 'package:todoapp/moduels/tasks/tasks_screen.dart';
class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex =0 ;
  List<Widget> screen = [
    TasksScreen(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titels = [
    'Tasks',
    'Done Tasks' ,
    'Archived Tasks',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: Text(
          titels[currentIndex],
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: screen[currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index)
        {
          setState(() {
            currentIndex =index ;
          });
        },
        elevation: 0.0,
        backgroundColor: Colors.blueGrey[900],
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              color: Colors.white,
              Icons.task,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              color: Colors.white,
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              color: Colors.white,
              Icons.archive_outlined,
            ),
            label: 'Archied',
          ),
        ],
      ),
    );
  }
}
