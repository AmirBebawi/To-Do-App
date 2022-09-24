import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/constants.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTasks extends StatefulWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  State<ArchivedTasks> createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        var tasks = AppCubit.get(context).archiveTasks;
        return Scaffold(
          backgroundColor: backGroundColor,
          body: tasksBuilder(tasks: tasks),
        );
      },
    );
  }
}
