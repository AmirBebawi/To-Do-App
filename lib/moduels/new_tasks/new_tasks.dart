import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/components.dart';

import '../../shared/components/constants.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => defaultTaskItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1.0 ,
          color: Colors.grey[300] ,
        ),
        itemCount: tasks.length ,
    );
  }
}
