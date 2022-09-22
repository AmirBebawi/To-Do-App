import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        onPressed: ()  async{
          try {

            var name = await get_Name() ;
            print(name);
            print('osama');
            throw('error');
          }
          catch(value)
          {
            print(value);
          }

        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text(
          'Amir',
          style: TextStyle(fontSize: 50, color: Colors.white),
        ),
      ),
    );
  }

  Future<String> get_Name() async {
    return 'ahmed ali';
  }
}
