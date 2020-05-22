import 'dart:isolate';
import 'dart:ui';

import 'package:PTasker/models/comment.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/shared/utils.dart';
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
    var commentsList = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text("КОЛ-ВО"),
        title: Text("Comments"),
        children:
            List<Widget>.generate(20, (int index) => Text(index.toString())),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          commentsList,
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: pColor(widget.project, 1)),
            child: TextComposer(),
          ),
        ],
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposingMessage = false;
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: _isComposingMessage
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 4.0),
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.photo_camera,
            //       color: Theme.of(context).accentColor,
            //     ),
            //     onPressed: () async {},
            //   ),
            // ),
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposingMessage = messageText.length > 0;
                  });
                },
                // onSubmitted: _textMessageSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                // onPressed: _isComposingMessage
                //     ? () => _textMessageSubmitted(_textEditingController.text)
                //     : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  final Comment comment;

  const _Comment({this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserPreview(user: comment.user),
          Text(
            comment.message,
            textAlign: TextAlign.left,
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}

class UserPreview extends StatelessWidget {
  final UserData user;

  UserPreview({this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile();
  }
}
