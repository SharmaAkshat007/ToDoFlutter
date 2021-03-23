import 'taskModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DB {
  Future<Database> connect() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE tasks(id TEXT PRIMARY KEY, task TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    final Database db = await connect();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await connect();

    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task(id: maps[i]['id'], task: maps[i]['task']);
    });
  }

  Future<void> updateTask(Task task) async {
    final Database db = await connect();

    await db.update(
      'tasks',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(Task task) async {
    final Database db = await connect();

    await db.delete('tasks', where: 'id=?', whereArgs: [task.id]);
  }
}
