import 'dart:io';

import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

var pColor = (Project p, double opacity) =>
    Color.fromRGBO(p.color['r'], p.color['g'], p.color['b'], opacity);

var getPercent = (List<Task> t) =>
    (t.where((e) => e.status == TaskStatus.closed).length / t.length);

var isDone =
    (List<Task> t) => t.where((e) => e.status == TaskStatus.closed).length;

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
      return Colors.amber;
      break;
    case TaskStatus.closed:
      return Colors.greenAccent[700];
      break;
    default:
      return Colors.grey;
      break;
  }
};

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
      if (t.priority == TaskPriority.medium || t.priority == TaskPriority.high)
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

Future<bool> isExist(String fileName) async {
  final dir = await getExternalStorageDirectory();
  print(dir);
  return File("${dir.path}/fileName").exists();
}
