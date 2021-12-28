class TaskModel {
  final int? taskId;
  final String? taskTitle;
  final String? taskDescrip;

  TaskModel({this.taskId, this.taskTitle, this.taskDescrip});

  Map<String, dynamic> mappingValues() {
    return {
      "id": taskId,
      "title": taskTitle,
      "description": taskDescrip,
    };
  }
}
