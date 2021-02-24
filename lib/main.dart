import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'To-Do-App',
    home: ToDo(),
  ));
}

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<String> tasks = [];

  void deleteList(int index) {
    setState(() {
      tasks.remove(tasks[index]);
    });
  }

  void addList(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  void listEntry() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          title: Text(
            "Add new task",
          ),
        ),
        body: TextField(
          autofocus: true,
          style: TextStyle(
            fontSize: 17,
          ),
          onSubmitted: (val) {
            if (val.isEmpty) {
              return 'Type something in';
            }
            addList(val);
            Navigator.pop(context);
          },
          decoration: InputDecoration(
            hintText: "Type something in...",
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
      );
    }));
  }

  Widget list(int index) {
    return Card(
      color: Colors.grey[850],
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            tasks[index],
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            color: Colors.red,
            onPressed: () {
              deleteList(index);
            },
            tooltip: 'Delete',
            icon: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          'To Do App',
          style: TextStyle(
            color: Colors.white,
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
                fontSize: 16.0,
              ),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: listEntry,
        elevation: 0.0,
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
