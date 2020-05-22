import 'dart:io';

import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/models/file_meta.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/screens/new_design/task/file_adder.dart';
import 'package:PTasker/screens/new_design/task/task_comments.dart';
import 'package:PTasker/screens/new_design/task/task_edit.dart';
import 'package:PTasker/services/auth.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/services/storage.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class TaskDetails extends StatefulWidget {
  final Project project;
  final Task task;
  TaskDetails({this.project, this.task});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(7.0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0)),
              child: StreamBuilder(
                  stream: DatabaseService(
                          uid: widget.project.uid, subuid: widget.task.uid)
                      .task,
                  builder: (context, snapshot) {
                    return Row(
                      children: <Widget>[
                        FaIcon(
                          statusToIcon(snapshot?.data ?? widget.task),
                          color: statusToColor(snapshot?.data ?? widget.task),
                          size: 24.0,
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(7.0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0)),
              child: FutureBuilder(
                initialData: widget.task,
                future: DatabaseService(
                        uid: widget.project.uid, subuid: widget.task.uid)
                    .getTask,
                builder: (context, snapshot) {
                  return getFireIcons(snapshot.data);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Text(
          widget.task.title,
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: DatabaseService(
                        uid: widget.project.uid, subuid: widget.task.uid)
                    .task,
                builder: (context, snapshot) {
                  return taskActions(snapshot.data);
                }),
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
          color: Colors.indigo[900],
          child: Center(
            child: topContentText,
          ),
        ),
      ],
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              expandedHeight: 230,
              backgroundColor: pColor(widget.project, 1),
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.settings),
                  onSelected: (String value) {
                    switch (value) {
                      case "edit":
                        Navigator.of(context)
                            .push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      TaskEdit(
                                          project: widget.project,
                                          task: widget.task),
                            ))
                            .then((value) => setState(() {}));
                        break;
                      case "deleteTask":
                        DatabaseService()
                            .deleteTask(widget.project, widget.task);
                        Navigator.pop(context);
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Редактировать"),
                      ),
                      PopupMenuItem(
                        value: "deleteTask",
                        child: Text("Удалить задачу"),
                      ),
                      //TODO: ВЗятие задачи и тд --- зависит от статуса задачи и привилегий пользователя
                    ];
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: topContent,
              ),
            ),
          ];
        },
        body: StreamBuilder<Task>(
            initialData: widget.task,
            stream: DatabaseService(
                    uid: widget.project.uid, subuid: widget.task.uid)
                .task,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final task = snapshot.data;
                var taskMainTextExpandable = ExpandableNotifier(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Описание задачи",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                            collapsed: Text(
                              task.mainText,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      task.mainText,
                                      softWrap: true,
                                      overflow: TextOverflow.fade,
                                    )),
                              ],
                            ),
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                  theme: const ExpandableThemeData(
                                      crossFadePoint: 0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                var relatedFiles = StreamBuilder<List<FileMeta>>(
                  stream: CouldStorageService(
                          projectUid: widget.project.uid,
                          taskUid: widget.task.uid)
                      .getFilesMeta(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(children: [
                        Wrap(
                          children: snapshot.data.map(
                            (e) {
                              return GestureDetector(
                                onTap: () async {
                                  if (await isExist(e.name)) {
                                    await CouldStorageService(
                                      projectUid: widget.project.uid,
                                      taskUid: widget.task.uid,
                                    )
                                        .downloadFile(e)
                                        .then((_) => setState(() {}));
                                  } else {
                                    final dir =
                                        (await getExternalStorageDirectory())
                                            .path;
                                    await OpenFile.open("$dir/${e.name}");
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            await CouldStorageService(
                                                    projectUid:
                                                        widget.project.uid,
                                                    taskUid: widget.task.uid)
                                                .deleteRelatedFile(e)
                                                .then((_) => setState(() {}));
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 16.0,
                                          ),
                                        ),
                                        Icon(
                                          Icons.assignment,
                                          size: 60.0,
                                        ),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                              ),
                                              text: e.name,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            File file =
                                await FilePicker.getFile(type: FileType.any);
                            CouldStorageService(
                              projectUid: widget.project.uid,
                              taskUid: widget.task.uid,
                            ).addRelatedFile(file);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Card(
                              child: Icon(
                                Icons.add,
                                size: 60.0,
                              ),
                            ),
                          ),
                        ),
                      ]);
                    } else {
                      return Loading();
                    }
                  },
                );

                return Column(
                  children: <Widget>[
                    taskMainTextExpandable,
                    ExpandableNotifier(
                      child: Card(
                        child: ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Закрепленные файлы",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                            expanded: relatedFiles,
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      TaskComments(
                                          project: widget.project,
                                          task: widget.task),
                            ))
                            .then((value) => setState(() {}));
                      },
                      child: Card(
                        child: Text("Открыть комментарии"),
                      ),
                    ),
                  ],
                );
              } else {
                return Loading();
              }
            }),
      ),
    );
  }

  Widget taskActions(Task task) {
    return StreamBuilder<User>(
        stream: AuthService().user,
        builder: (context, userSnap) {
          if (userSnap.hasData) {
            User user = userSnap.data;

            return FutureBuilder<UserData>(
                future: DatabaseService().getUserData(user.uid),
                builder: (context, snapshot) {
                  bool isTakenByCurrUser =
                      task.relatedUserUids.contains(user.uid);

                  switch (task.status) {
                    case TaskStatus.open:
                      return RaisedButton(
                        child: Text("Взяться за задачу"),
                        color: Colors.green,
                        onPressed: () {
                          DatabaseService().updateTask(
                              widget.project,
                              task.copy(
                                  relatedUserUids: [user.uid],
                                  status: TaskStatus.taken));
                        },
                      );
                      break;
                    case TaskStatus.taken:
                      if (snapshot.data.isAdmin || isTakenByCurrUser)
                        return Row(
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.red,
                              child: Text("Отказаться"),
                              onPressed: () {
                                DatabaseService().updateTask(widget.project,
                                    task.copy(status: TaskStatus.open));
                              },
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            RaisedButton(
                              child: Text("Отправить на проверку"),
                              onPressed: () {
                                DatabaseService().updateTask(widget.project,
                                    task.copy(status: TaskStatus.onApprove));
                              },
                            ),
                          ],
                        );
                      if (!snapshot.data.isAdmin)
                        return RaisedButton(
                          color: Colors.red,
                          child: Text("Уже забрали"),
                          onPressed: () {},
                        );
                      break;
                    case TaskStatus.onApprove:
                      if (snapshot.data.isAdmin)
                        return Row(
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.red,
                              child: Text("Доделать"),
                              onPressed: () {
                                DatabaseService().updateTask(widget.project,
                                    task.copy(status: TaskStatus.taken));
                              },
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            RaisedButton(
                              color: Colors.green,
                              child: Text("Одобрить"),
                              onPressed: () {
                                DatabaseService().updateTask(widget.project,
                                    task.copy(status: TaskStatus.closed));
                              },
                            ),
                          ],
                        );
                      if (!snapshot.data.isAdmin)
                        return RaisedButton(
                          color: Colors.amber,
                          child: Text("На проверке"),
                          onPressed: () {},
                        );
                      break;
                    case TaskStatus.closed:
                      if (snapshot.data.isAdmin)
                        return Row(
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.red,
                              child: Text("Откатить"),
                              onPressed: () {
                                DatabaseService().updateTask(widget.project,
                                    task.copy(status: TaskStatus.taken));
                              },
                            ),
                            // SizedBox(
                            //   width: 20.0,
                            // ),
                            // RaisedButton(
                            //   child: Text("Откатить"),
                            //   onPressed: () {},
                            // ),
                          ],
                        );
                      if (!snapshot.data.isAdmin)
                        return RaisedButton(
                          color: Colors.green,
                          child: Text("Сдано"),
                          onPressed: () {},
                        );
                      break;
                  }
                });
          } else {
            return Loading();
          }
        });
  }
}
