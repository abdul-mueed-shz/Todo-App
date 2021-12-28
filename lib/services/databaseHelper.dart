import 'dart:ffi';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/models/tasksmodel.dart';
import 'package:todo/services/models/todomodel.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
        await db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, taskID INTEGER , title TEXT, isFinished INTEGER)',
        );
        return Future.value();
      },
      version: 1,
    );
  }

  Future<void> updateTheTaskTitle(int? id, String newTitle) async {
    Database _taskDB = await database();
    await _taskDB
        .rawUpdate("UPDATE tasks SET title = '${newTitle}' WHERE id = '${id}'");
  }

  Future<void> updateTheTaskDescription(int? id, String newDescrip) async {
    Database _taskDB = await database();
    await _taskDB.rawUpdate(
        "UPDATE tasks SET description = '${newDescrip}' WHERE id = '${id}'");
  }

  Future<void> updateTheTodoState(int? id, int todoState) async {
    Database _taskDB = await database();
    await _taskDB.rawUpdate(
        "UPDATE todo SET isFinished = '${todoState}' WHERE id = '${id}'");
  }

  Future<void> deleteTask(int? id) async {
    Database _taskDB = await database();
    await _taskDB.rawDelete("DELETE FROM tasks WHERE id = '${id}'");
    await _taskDB.rawDelete("DELETE FROM todo WHERE taskID = '${id}'");
  }

  Future<int> insertTaskIntoDatabase(TaskModel task) async {
    int taskId = 0;
    Database _taskDB = await database();
    await _taskDB
        .insert('tasks', task.mappingValues(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => taskId = value);
    return taskId;
  }

  Future<void> insertTodoIntoDatabase(TodoModel todo) async {
    Database _todoDB = await database();
    await _todoDB.insert('todo', todo.mappingValues(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TaskModel>> getTasks() async {
    Database _taskDB = await database();
    List<Map<String, dynamic>> taskMap = await _taskDB.query('tasks');
    return List.generate(
        taskMap.length,
        (index) => TaskModel(
            taskId: taskMap[index]['id'],
            taskTitle: taskMap[index]['title'],
            taskDescrip: taskMap[index]['description']));
  }

  Future<List<TodoModel>> getTodos(int? taskId) async {
    Database _todoDB = await database();
    List<Map<String, dynamic>> todoMap =
        await _todoDB.rawQuery("SELECT * FROM todo WHERE taskID = ${taskId}");
    return List.generate(
      todoMap.length,
      (index) => TodoModel(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        isFinished: todoMap[index]['isFinished'],
        taskID: todoMap[index]['taskID'],
      ),
    );
  }
}
