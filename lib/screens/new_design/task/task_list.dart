import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskList extends StatefulWidget {
  final Project project;

  TaskList({this.project});

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
                    if (!snapshot.hasData) {
                      return Center(child: Loading());
                    } else {
                      Project project = snapshot.data;
                      List<Task> tasks = project.relatedTasks;
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
                                            animation: true,
                                            animationDuration: 800,
                                            backgroundColor:
                                                pColor(project, 0.4),
                                            progressColor: pColor(project, 1),
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
                                        isDone(project).toString() +
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
                            buildList(context, project),
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

  Widget buildList(BuildContext context, Project project) {
    var tasks = project.relatedTasks;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 0.0, right: 20.0),
        child: ListView.builder(
          itemCount: tasks.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              subtitle: Text(
                "Сделать до " +
                    DateFormat('yyyy-MM-dd - kk:mm')
                        .format(tasks[index].dateOfCompletion),
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
              trailing: getFireIcons(tasks[index]),
            );
          },
        ),
      ),
    );
  }

  Stack getFireIcons(Task t) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        if (t.priority == TaskPriority.high)
          Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: Icon(
              FontAwesomeIcons.fire,
              color: Colors.red,
              size: 30.0,
            ),
          ),
        if (t.priority == TaskPriority.medium ||
            t.priority == TaskPriority.high)
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(
              FontAwesomeIcons.fire,
              color: Colors.red,
              size: 24.0,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Icon(
            FontAwesomeIcons.fire,
            color: Colors.red,
            size: 20.0,
          ),
        )
      ],
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

  var pColor = (Project p, double opacity) =>
      Color.fromRGBO(p.color['r'], p.color['g'], p.color['b'], opacity);

  var getPercent = (Project p) =>
      (p.relatedTasks.where((e) => e.status == TaskStatus.closed).length /
          p.relatedTasks.length);

  var isDone = (Project p) => p.relatedTasks
      .where((element) => element.status == TaskStatus.closed)
      .length;

  var statusToIcon = (Task t) {
    switch (t.status) {
      case TaskStatus.open:
        return FontAwesomeIcons.solidQuestionCircle;
        break;
      case TaskStatus.taken:
        return FontAwesomeIcons.infoCircle;
        break;
      case TaskStatus.onApprove:
        return FontAwesomeIcons.check;
        break;
      case TaskStatus.closed:
        return FontAwesomeIcons.checkDouble;
        break;
      default:
        return FontAwesomeIcons.minus;
        break;
    }
  };

  var statusToColor = (Task t) {
    switch (t.status) {
      case TaskStatus.open:
        return Colors.blue[700];
        break;
      case TaskStatus.taken:
        return Colors.grey;
        break;
      case TaskStatus.onApprove:
        return Colors.grey;
        break;
      case TaskStatus.closed:
        return Colors.greenAccent[700];
        break;
      default:
        return Colors.grey;
        break;
    }
  };
}
