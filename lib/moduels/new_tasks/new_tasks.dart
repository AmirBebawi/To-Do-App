import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class NewTasks extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        AppCubit cubit = AppCubit.get(context);
        var tasks = AppCubit.get(context).newTasks;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: color,
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        padding: const EdgeInsets.all(20.0),
                        color: backGroundColor,
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
          backgroundColor: backGroundColor,
          body: tasksBuilder(tasks: tasks),
        );
      },
    );
  }
}
