class Task {
  final String id;
  final String task;

  Task({this.id, this.task});

  Map<String, dynamic> toMap() {
    return {'id': this.id, 'task': this.task};
  }
}
