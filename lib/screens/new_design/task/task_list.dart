import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/screens/new_design/project/project_edit_create.dart';
import 'package:PTasker/screens/new_design/task/task_details.dart';
import 'package:PTasker/screens/new_design/task/task_edit.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskList extends StatefulWidget {
  final Project project;

  TaskList({this.project});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _getToolbar(context),
          _buildPage(),
        ],
      ),
    );
  }

  Container _buildPage() {
    return Container(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: StreamBuilder<List<Task>>(
            stream: DatabaseService(uid: widget.project.uid).tasks,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              } else {
                List<Task> tasks = snapshot.data;
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularPercentIndicator(
                                      radius: 80.0,
                                      lineWidth: 4.0,
                                      animation: true,
                                      animationDuration: 800,
                                      backgroundColor:
                                          pColor(widget.project, 0.4),
                                      progressColor: pColor(widget.project, 1),
                                      percent: getPercent(tasks),
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
                                  widget.project.name,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0),
                                ),
                                Text(
                                  isDone(tasks).toString() +
                                      " из " +
                                      tasks.length.toString() +
                                      " задач сделаны ",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black54),
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
                      buildList(context, widget.project, tasks),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget buildList(BuildContext context, Project project, List<Task> tasks) {
    return Expanded(
      child: Container(
        color: pColor(project, 0.2),
        child: Padding(
          padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
          child: ListView.builder(
            itemCount: tasks.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        TaskDetails(project: project, task: tasks[index]),
                  ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 30.0),
                    leading: Icon(
                      statusToIcon(tasks[index]),
                      size: 30.0,
                      color: statusToColor(tasks[index]),
                    ),
                    title: Text(
                      tasks[index].title,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      "Сделать до " +
                          DateFormat('yyyy-MM-dd - kk:mm')
                              .format(tasks[index].dateOfCompletion),
                      style: TextStyle(fontSize: 12.0, color: Colors.black54),
                    ),
                    trailing: getFireIcons(tasks[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _getToolbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.settings),
            onSelected: (String value) {
              switch (value) {
                case "addTask":
                  Navigator.of(context)
                      .push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            TaskEdit(project: widget.project),
                      ))
                      .then((value) => setState(() {}));
                  break;
                case "editProject":
                  Navigator.of(context)
                      .push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProjectEditCreate(project: widget.project),
                      ))
                      .then((value) => setState(() {}));
                  break;
                case "deleteProject":
                  DatabaseService().deleteProject(widget.project);
                  Navigator.pop(context);
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "addTask",
                  child: Text("Добавить задачу"),
                ),
                PopupMenuItem(
                  value: "editProject",
                  child: Text("Редактировать"),
                ),
                PopupMenuItem(
                  value: "deleteProject",
                  child: Text("Удалить проект"),
                ),
                //TODO: ВЗятие задачи и тд --- зависит от статуса задачи и привилегий пользователя
              ];
            },
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
