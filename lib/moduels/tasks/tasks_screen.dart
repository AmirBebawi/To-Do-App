import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Amir',
        style: TextStyle(
          fontSize: 50,
          color: Colors.white
        ),
      ),
    );
  }
}
