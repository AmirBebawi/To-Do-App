import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../moduels/archived_tasks/archived_tasks.dart';
import '../../moduels/done_tasks/done_tasks.dart';
import '../../moduels/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitalState());

   static AppCubit get(context) {
     return BlocProvider.of(context);
   }

  List<Map> tasks = [];
  Database? database;

  void createDatabase() {
    openDatabase(
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
          emit(AppGetDataFromDatabaseState());
        });
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
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
        emit(AppInsertDataToDatabaseState());
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database!.rawQuery('SELECT * FROM tasks');
  }

  int currentIndex = 0;
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

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  bool isBottomSheetShown = false;
  IconData fbIcon = Icons.edit;
  void changeBottomSheetState(
  {
  @required bool ? isShown ,
  @required IconData ? icon ,
  })
  {
    isBottomSheetShown = isShown! ;
    fbIcon = icon! ;
    emit(AppChangeBottomSheetState());
  }
}
