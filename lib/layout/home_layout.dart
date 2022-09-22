import 'package:flutter/material.dart';
import 'package:todoapp/moduels/archived_tasks/archived_tasks.dart';
import 'package:todoapp/moduels/done_tasks/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import '../moduels/new_tasks/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  Database? database;

  @override
  void initState() {
    super.initState();
    creatDatabase();
  }

  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titels = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        onPressed: () {
          scaffoldKey.currentState!.showBottomSheet(
                  (context) => Container(
                    width: double.infinity,
                  ),
          );
        },
        child: Icon(Icons.add),
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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

  Future<String> get_Name() async {
    return 'ahmed ali';
  }

  void creatDatabase() async {
    database = await openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print("Error when creating Table : ${error.toString()}");
        });
      },
      onOpen: (database) {
        print('Database Opened');
      },
    );
  }

  void insertToDatabase() async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("some name", "000000", "xzczxcxz", "sadsadsa")',
      )
          .then((value) {
        print('${value}  Inserted Sucssefully');
      }).catchError((error) {
        print('Error when data inset to database : ${error.toString()}');
      });
    });
  }

  void deletFromDatabase() {}

  void updateIntoDatabase() {}
}
