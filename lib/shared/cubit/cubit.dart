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

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
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
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
    String? status = 'new',
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "$status")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDataFromDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataFromDatabaseState());
    });
  }

  void deleteDataFromDatabase({
    @required int? id,
  }) {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id] ,
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataFromDatabaseState());
    });
  }

  void updateDataInDatabase({
    @required String? status,
    @required int? id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', '$id'],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataInDatabaseState());
    });
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

  void changeBottomSheetState({
    @required bool? isShown,
    @required IconData? icon,
  }) {
    isBottomSheetShown = isShown!;
    fbIcon = icon!;
    emit(AppChangeBottomSheetState());
  }
}
