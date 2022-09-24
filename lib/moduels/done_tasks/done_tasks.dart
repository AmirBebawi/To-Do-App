import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/constants.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasks extends StatefulWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  State<DoneTasks> createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return Scaffold(
          backgroundColor: backGroundColor,
          body: tasksBuilder(tasks: tasks),
        );
      },
    );
  }
}
