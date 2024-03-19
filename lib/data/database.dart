import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  final _myBox = Hive.box('myBox');

  // run this method if this is the 1st time ever opening the app.
  void createIntitalData() {
    toDoList = [
      ['Task 1', false],
      ['Task 2', false],
    ];
  }

  void upadateData() {
    _myBox.put('toDoList', toDoList);
  }

  void loadData() {
    toDoList = _myBox.get('toDoList');
  }
}
