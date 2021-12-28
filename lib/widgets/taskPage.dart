import 'package:flutter/material.dart';
import 'package:todo/services/databaseHelper.dart';
import 'package:todo/services/models/tasksmodel.dart';
import 'package:todo/services/models/todomodel.dart';
import 'package:todo/widgets/Home.dart';
import 'package:todo/widgets/todoList.dart';

class TaskPage extends StatefulWidget {
  final TaskModel? task;
  TaskPage({required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  FocusNode? _title;
  FocusNode? _description;
  FocusNode? _todo;

  DatabaseHelper _databaseHelper = DatabaseHelper();
  String _titleofTask = "";
  String _descriptionofTask = "";
  String _todoText = "";

  int? _taskid = 0;

  bool _contentVisibility = false;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.task != null) {
      _contentVisibility = true;
      _titleofTask = (widget.task?.taskTitle).toString();
      if ((widget.task?.taskDescrip).toString() == null) {
        _descriptionofTask = "[Unspecified]";
      } else {
        _descriptionofTask = (widget.task?.taskDescrip).toString();
      }
      //_titleofTask = _titleofTask.toString();
      _taskid = (widget.task?.taskId)?.toInt();
    }

    _title = FocusNode();
    _description = FocusNode();
    _todo = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _title?.dispose();
    _description?.dispose();
    _todo?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      bottom: 0.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _title,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  TaskModel task = TaskModel(
                                    taskTitle: value,
                                  );
                                  _taskid = await DatabaseHelper()
                                      .insertTaskIntoDatabase(task);
                                  print("New Task Added with ID:${_taskid}");
                                  setState(() {
                                    _contentVisibility = true;
                                    _titleofTask = value;
                                  });
                                } else {
                                  await _databaseHelper.updateTheTaskTitle(
                                      _taskid, value);
                                  print("Task Title Updated");
                                }
                              }
                              _description?.requestFocus();
                            },
                            controller: TextEditingController()
                              ..text = _titleofTask,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter the Title",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextField(
                        focusNode: _description,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskid != 0) {
                              await _databaseHelper.updateTheTaskDescription(
                                  _taskid, value);
                              _descriptionofTask = value;
                            }
                          }
                          _todo?.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _descriptionofTask,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            hintText: "Enter the Description",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 30,
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisibility,
                    child: FutureBuilder(
                      builder:
                          (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                        return Expanded(
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data?[index].isFinished == 0) {
                                      await _databaseHelper.updateTheTodoState(
                                          snapshot.data?[index].id, 1);
                                      print(
                                          "Todo finished: ${snapshot.data?[index].isFinished}");
                                    } else {
                                      await _databaseHelper.updateTheTodoState(
                                          snapshot.data?[index].id, 0);
                                      print(
                                          "Todo reset: ${snapshot.data?[index].isFinished}");
                                    }
                                    setState(() {});
                                  },
                                  child: ToDo(
                                    textField: snapshot.data?[index].title,
                                    isFinished:
                                        snapshot.data?[index].isFinished == 0
                                            ? false
                                            : true,
                                  ),
                                );
                              },
                              itemCount: snapshot.data?.length),
                        );
                      },
                      future: _databaseHelper.getTodos(_taskid),
                      //initialData: [],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisibility,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.grey[500],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todo,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskid != 0) {
                                    DatabaseHelper _databaseHelper =
                                        DatabaseHelper();
                                    TodoModel todo = TodoModel(
                                      title: value,
                                      isFinished: 0,
                                      taskID: _taskid,
                                    );
                                    await DatabaseHelper()
                                        .insertTodoIntoDatabase(todo);
                                    setState(() {});
                                    _todo?.requestFocus();
                                    print("New ToDo Added");
                                  } else {
                                    print("Updating the existing ToDo");
                                  }
                                }
                              },
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter the task item",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisibility,
                child: Positioned(
                  bottom: 20.0,
                  right: 25.0,
                  child: Container(
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (_taskid != 0) {
                          await _databaseHelper.deleteTask(_taskid);
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.delete,
                      ),
                      backgroundColor: Colors.red[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
