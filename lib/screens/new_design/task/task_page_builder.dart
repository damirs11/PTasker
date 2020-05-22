import 'package:PTasker/models/project.dart';
import 'package:PTasker/screens/new_design/task/task_list.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:flutter/material.dart';

class TaskPageBuilder extends StatefulWidget {
  // final Project project;
  final int index;

  const TaskPageBuilder({Key key, this.index}) : super(key: key);

  @override
  _TaskPageBuilderState createState() => _TaskPageBuilderState();
}

class _TaskPageBuilderState extends State<TaskPageBuilder> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = new PageController(
      initialPage: widget.index,
    );

    var tSort = (List<Project> p) =>
        p.sort((a, b) => a.dateOfCreation.compareTo(b.dateOfCreation));

    return FutureBuilder<List<Project>>(
        future: DatabaseService().getProjects,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            tSort(snapshot.data);
            return PageView.builder(
              controller: pageController,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskList(project: snapshot.data[index]);
              },
            );
          } else {
            return Loading();
          }
        });
  }
}
