import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import '../shared/components/components.dart';
import 'package:intl/intl.dart';
import '../shared/components/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    // cubit.insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // )
                    //     .then((value) {
                    //   cubit.getDataFromDatabase(cubit.database)
                    //       .then((value) {
                    //     Navigator.pop(context);
                    // setState(() {
                    //   fbIcon = Icons.edit;
                    //   tasks = value;
                    //   isBottomSheetShown = false;
                    // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.black87,
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
                                        timeController.text =
                                            value!.format(context);
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
                                              keyboardType:
                                                  TextInputType.datetime,
                                              context: context,
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-10-22'),
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
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fbIcon,
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.amber,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                cubit.titels[cubit.currentIndex],
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.black54,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.amber,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
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
        },
      ),
    );
  }
}
