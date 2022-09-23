import 'package:flutter/material.dart';
import 'package:todoapp/moduels/archived_tasks/archived_tasks.dart';
import 'package:todoapp/moduels/done_tasks/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import '../moduels/new_tasks/new_tasks.dart';
import '../shared/components/components.dart';
import 'package:intl/intl.dart';

import '../shared/components/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  // Title Controller to get data of title from user
  var titleController = TextEditingController();

  //Date Controller to get data of title from user
  var dateController = TextEditingController();

  //Time Controller to get data of title from user
  var timeController = TextEditingController();

  //fbIcon this icon for the floating action button
  IconData fbIcon = Icons.edit;

  // this variable control open and off the bottom sheet
  bool isBottomSheetShown = false;

  //this key to get bottom sheet
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //this key to validate tha data
  var formKey = GlobalKey<FormState>();

  // to tog-el between screens
  int currentIndex = 0;

  // this variable to create database
  Database? database;

  @override
  void initState() {
    super.initState();
    createDatabase();
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
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate())
            {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                getDataFromDatabase(database).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    fbIcon = Icons.edit;
                    tasks = value;
                    isBottomSheetShown = false;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => Container(
                    padding: const EdgeInsets.all(20.0),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextForm(
                              validateFunction: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                } else {
                                  return null;
                                }
                              },
                              textInputType: TextInputType.text,
                              controller: titleController,
                              prefixIcon: Icons.title,
                              labelText: ' Task Title ',
                              raduis: 5.0),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTextForm(
                              functionOnTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value!.format(context);
                                });
                              },
                              validateFunction: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Time must not be empty';
                                } else {
                                  return null;
                                }
                              },
                              textInputType: TextInputType.datetime,
                              controller: timeController,
                              prefixIcon: Icons.watch_later_outlined,
                              labelText: ' Task Time ',
                              raduis: 5.0),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTextForm(
                              functionOnTap: () {
                                showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-10-22'),
                                        initialDate: DateTime.now())
                                    .then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              validateFunction: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Date must not be empty';
                                } else {
                                  return null;
                                }
                              },
                              textInputType: TextInputType.datetime,
                              controller: dateController,
                              prefixIcon: Icons.calendar_today,
                              labelText: ' Task Date ',
                              raduis: 5.0),
                        ],
                      ),
                    ),
                  ),
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fbIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fbIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fbIcon,
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          titels[currentIndex],
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) => screen[currentIndex],
        fallback: (context) => Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archied',
          ),
        ],
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
        });
        print('database opened');
      },
    );
  }

  Future insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
    String? status = 'new',
  }) async {
    return await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "$status")',
      )
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database!.rawQuery('SELECT * FROM tasks');
  }

  void deleteFromDatabase() {}

  void updateIntoDatabase() {}
}
