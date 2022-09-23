import 'package:flutter/material.dart';

class ArchivedTasks extends StatefulWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  State<ArchivedTasks> createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        'Ami2.0r',
        style: TextStyle(
            fontSize: 50,
            color: Colors.white
        ),
      ),
    );
  }
}
