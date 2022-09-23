import 'package:flutter/material.dart';
import 'package:todoapp/moduels/archived_tasks/archived_tasks.dart';
import 'package:todoapp/moduels/done_tasks/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import '../moduels/new_tasks/new_tasks.dart';
import '../shared/components/components.dart';
import 'package:intl/intl.dart';
class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleController = TextEditingController();

  var dateController = TextEditingController();

  var timeController = TextEditingController();

  IconData fbIcon = Icons.edit;

  bool isBottomSheetShown = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  int currentIndex = 0;

  Database? database;

  @override
  void initState() {
    super.initState();
    creatDatabase();
  }

  List<Widget> screen = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
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
              if(formKey.currentState!.validate())
                {
                  insertToDatabase(
                    title: titleController.text ,
                    date: dateController.text ,
                    time: timeController.text ,
                  ).then((value) {
                    Navigator.pop(context);
                    isBottomSheetShown = false;
                    setState(() {
                      fbIcon = Icons.edit ;
                    });
                  });
                }
            }
            else {
              scaffoldKey.currentState!.showBottomSheet(
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
                                timeController.text = value!.format(context) ;
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
                                context: context ,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2022-10-22') ,
                                initialDate: DateTime.now()
                              ).then((value)
                                  {
                                   dateController.text= DateFormat.yMMMd().format(value!);
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
                ),).closed.then((value)
              {
                isBottomSheetShown = false;
                setState(() {
                  fbIcon = Icons.edit ;
                });
              });
              isBottomSheetShown = true;
              setState(() {
                fbIcon = Icons.add ;
              });
            }
        },
        child: Icon(fbIcon,),
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
        items:  [
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

  void creatDatabase() async {
    database = await openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
        }).catchError((error) {
        });
      },
      onOpen: (database) {
      },
    );
  }

    Future insertToDatabase(
  {
  @required String ? title ,
  @required String ? time ,
  @required String ? date ,
   String ? status = 'new' ,
  }) async {
    return await database!.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$time", "$date", "$status")',
      )
          .then((value) {
            print('$value  inserted Successfully');
      }).catchError((error) {
        print('Error when  inserting new record : ${error.toString()}');
      });
    });
  }

  void deleteFromDatabase() {}
  void updateIntoDatabase() {}
}
