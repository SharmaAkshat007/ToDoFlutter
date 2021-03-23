import 'package:flutter/material.dart';
import 'package:to_do_app/dbHandler.dart';
import 'package:to_do_app/taskModel.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MaterialApp(
    title: 'To-Do-App',
    home: ToDo(),
    debugShowCheckedModeBanner: false,
  ));
}

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<Task> tasks = [];
  var uuid = Uuid();

  bool _spin = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _spin = true;
    });
    getList();
  }

  void getList() async {
    List<Task> dataBack = await DB().getTasks();
    setState(() {
      this.tasks = dataBack;

      _spin = false;
    });
  }

  void updateList(int index, String updatedTask) async {
    setState(() {
      _spin = true;
    });
    await DB().updateTask(Task(id: tasks[index].id, task: updatedTask));
    getList();
  }

  void deleteList(int index) async {
    setState(() {
      _spin = true;
    });
    await DB().deleteTask(tasks[index]);
    getList();
  }

  void addList(String task) async {
    String id = uuid.v1();
    setState(() {
      _spin = true;
    });
    await DB().insertTask(Task(id: id, task: task));
    getList();
  }

  void listEntry() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 20.0,
          backgroundColor: Colors.red,
          title: Text(
            "Add new task",
            style: TextStyle(fontSize: 23),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20, right: 15, left: 15),
          child: TextField(
            autofocus: true,
            style: TextStyle(
              fontSize: 19,
            ),
            onSubmitted: (val) {
              if (val.isEmpty) {
                return 'Type new task';
              }
              addList(val);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              hintText: "Type new task",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        ),
      );
    }));
  }

  void updateEntry(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 20.0,
          backgroundColor: Colors.red,
          title: Text(
            "Update your task",
            style: TextStyle(fontSize: 23),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20, right: 15, left: 15),
          child: TextField(
            autofocus: true,
            style: TextStyle(
              fontSize: 19,
            ),
            onSubmitted: (val) {
              if (val.isEmpty) {
                return 'Type updated task';
              }
              updateList(index, val);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              hintText: "Type updated task",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 19,
              ),
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        ),
      );
    }));
  }

  Widget list(int index) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
        margin: EdgeInsets.only(top: 12, bottom: 12),
        color: Colors.white,
        elevation: 20.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              tasks[index].task,
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
              ),
            ),
            trailing: UnconstrainedBox(
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.blue,
                      onPressed: () {
                        updateEntry(index);
                      },
                      icon: Icon(Icons.mode_edit),
                      tooltip: 'Update',
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      color: Colors.green,
                      onPressed: () {
                        deleteList(index);
                      },
                      tooltip: 'Delete',
                      icon: Icon(Icons.check_circle_outline_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _spin
        ? Scaffold(
            appBar: AppBar(
              elevation: 20.0,
              backgroundColor: Colors.red,
              title: Center(
                  child: Text(
                'MyTask',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              )),
            ),
            body: Center(
              child: Container(
                color: Colors.white,
                child: SpinKitRing(
                  color: Colors.red,
                  lineWidth: 3,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: listEntry,
              elevation: 20.0,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 20.0,
              backgroundColor: Colors.red,
              title: Center(
                  child: Text(
                'MyTask',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              )),
            ),
            body: tasks.isNotEmpty
                ? ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return list(index);
                    },
                  )
                : Center(
                    child: Text(
                    'Add a new Task',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
            floatingActionButton: FloatingActionButton(
              onPressed: listEntry,
              elevation: 20.0,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
            ),
          );
  }
}
