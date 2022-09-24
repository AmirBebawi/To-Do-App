import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ListView.separated(
        itemBuilder: (context, index) =>
            defaultTaskItem(AppCubit.get(context).tasks[index]),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
        itemCount: AppCubit.get(context).tasks.length,
      ),
    );
  }
}
