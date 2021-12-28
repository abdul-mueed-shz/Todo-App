class TodoModel {
  final int? id;
  final String? title;
  final int? isFinished;
  final int? taskID;

  TodoModel({this.taskID, this.id, this.title, this.isFinished});

  Map<String, dynamic> mappingValues() {
    return {
      "taskID": taskID,
      "id": id,
      "title": title,
      "isFinished": isFinished,
    };
  }
}
