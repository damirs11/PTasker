import 'dart:isolate';
import 'dart:ui';

import 'package:PTasker/models/comment.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class TaskComments extends StatefulWidget {
  final Project project;
  final Task task;

  const TaskComments({this.project, this.task});

  @override
  _TaskCommentsState createState() => _TaskCommentsState();
}

class _TaskCommentsState extends State<TaskComments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              print("toggle");
            },
            leading: Icon(Icons.comment),
            trailing: Text("КОЛ-ВО"),
            title: Text("Comments"),
            children: List<Widget>.generate(
              0,
              (int index) => Text("1"),
            ),
          ),
        ),
      ],
    );
  }
}


