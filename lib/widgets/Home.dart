import 'package:flutter/material.dart';
import 'package:todo/services/databaseHelper.dart';
import 'package:todo/services/glowremoval.dart';
import 'package:todo/services/models/tasksmodel.dart';
import 'package:todo/widgets/taskPage.dart';
import 'package:todo/widgets/tasks.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 35,
                      top: 20,
                    ),
                    height: 65,
                    width: 65,
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _databaseHelper.getTasks(),
                      builder:
                          (context, AsyncSnapshot<List<TaskModel>> snapshot) {
                        return ScrollConfiguration(
                          behavior: glowRemovel(),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return TaskPage(
                                      task: snapshot.data?[index],
                                    );
                                  })).then((value) {
                                    setState(
                                      () {},
                                    );
                                  });
                                },
                                child: Tasks(
                                  title: snapshot.data?[index].taskTitle,
                                  description:
                                      snapshot.data?[index].taskDescrip,
                                ),
                              );
                            },
                            itemCount: snapshot.data?.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20.0,
                right: 0.0,
                child: Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPage(
                                    task: null,
                                  ))).then((value) {
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.add,
                    ),
                    backgroundColor: Color(0xFFe05a00),
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
