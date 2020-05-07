import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskList extends StatefulWidget {
  final Project project;
  final String color;

  TaskList({this.project, this.color});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController itemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _getToolbar(context),
          Container(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: StreamBuilder<Project>(
                  stream: DatabaseService(uid: widget.project.uid).project,
                  builder: (context, snapshot) {
                    Project project = snapshot.data;
                    List<Task> tasks = project.relatedTasks;
                    var pColor = (Project p) => Color.fromRGBO(
                        p.color['r'], p.color['g'], p.color['b'], 1);
                    double Function(Project) getPercent = (Project p) {
                      return (p.relatedTasks
                              .where((e) => e.status == TaskStatus.closed)
                              .length /
                          p.relatedTasks.length);
                    };

                    if (!snapshot.hasData) {
                      return Center(child: Loading());
                    } else {
                      int isDone = project.relatedTasks
                          .where(
                              (element) => element.status == TaskStatus.closed)
                          .length;
                      return Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Container(
                                margin: EdgeInsets.only(right: 140.0),
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircularPercentIndicator(
                                            radius: 80.0,
                                            lineWidth: 4.0,
                                            percent: getPercent(project),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        project.name,
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35.0),
                                      ),
                                      Text(
                                        isDone.toString() +
                                            " из " +
                                            project.relatedTasks.length
                                                .toString() +
                                            " задач сделаны ",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Container(
                                margin: EdgeInsets.only(left: 140.0),
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            buildList(context, tasks),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildList(BuildContext context, List<Task> tasks) {
    return Padding(
      padding: EdgeInsets.only(top: 0.0),
      child: ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.only(left: 30.0),
            leading: Icon(Icons.ac_unit),
            title: Text(
              tasks[index].title,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
            subtitle: Text(
              tasks[index].dateOfCreation.toIso8601String(),
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }

  _getToolbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.settings),
            onTap: () {}, //TODO:
          ),
          GestureDetector(
            child: Icon(Icons.close),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
