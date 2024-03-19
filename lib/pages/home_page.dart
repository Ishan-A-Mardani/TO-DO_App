import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/data/database.dart';
import '../util/todo_tile.dart';
import 'package:to_do/util/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final _myBox = Hive.box('myBox');

  ToDoDatabase database = ToDoDatabase();

  @override
  void initState() {
    // If this is the 1st time ever opening the app.
    if (_myBox.get('toDoList') == null) {
      database.createIntitalData();
    } else {
      database.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(int index) {
    setState(() {
      database.toDoList[index][1] = !database.toDoList[index][1];
    });
    database.upadateData();
  }

  void saveNewTask() {
    setState(() {
      database.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    database.upadateData();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          // onSave: saveNewTask,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    database.upadateData();
  }

  void deleteTask(int index) {
    setState(() {
      database.toDoList.removeAt(index);
    });
    database.upadateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      appBar: AppBar(
        title: const Text('TO DO APP'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: database.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: database.toDoList[index][0],
            taskCompleted: database.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
          // ToDoTile(
          //   taskName: 'Task 1',
          //   taskCompleted: false,
          //   onChanged: (value) {},
          // ),
          // ToDoTile(
          //   taskName: 'Task 2',
          //   taskCompleted: true,
          //   onChanged: (value) {},
          // ),
