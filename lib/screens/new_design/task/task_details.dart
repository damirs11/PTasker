import 'dart:io';

import 'package:PTasker/models/comment.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/models/file_meta.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/screens/new_design/task/filesList.dart';
import 'package:PTasker/screens/new_design/task/task_edit.dart';
import 'package:PTasker/services/auth.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/services/storage.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  bool textInputVisibility = false;
  bool hasFiles = false;
  List<FileMeta> inputFilesMeta = [];

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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
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
              uid: widget.project.uid,
              subuid: widget.task.uid,
            ).task,
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

                var relatedFilesExpandable = ExpandableNotifier(
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
                        expanded: StreamBuilder(
                            stream: DatabaseService(
                              uid: widget.project.uid,
                              subuid: widget.task.uid,
                            ).getRelatedFilesMeta(),
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return Loading();
                              }
                              return FilesList(
                                files: snapshot.data,
                                allowAdding: true,
                                onFileTap: (fileMeta) async {
                                  if (!(await isExist(
                                      context, fileMeta.name))) {
                                    await CouldStorageService(
                                      projectUid: widget.project.uid,
                                      taskUid: widget.task.uid,
                                    )
                                        .downloadFile(fileMeta)
                                        .then((_) => setState(() {}));
                                  } else {
                                    final dir =
                                        (await getExternalStorageDirectory())
                                            .path;
                                    await OpenFile.open(
                                        "$dir/${fileMeta.name}");
                                  }
                                },
                                onFileDelete: (fileMeta) async {
                                  await CouldStorageService(
                                          projectUid: widget.project.uid,
                                          taskUid: widget.task.uid)
                                      .deleteRelatedFile(fileMeta)
                                      .then((_) => setState(() {}));
                                },
                                onFileAdd: () async {
                                  File file = await FilePicker.getFile(
                                      type: FileType.any);
                                  CouldStorageService(
                                    projectUid: widget.project.uid,
                                    taskUid: widget.task.uid,
                                  ).addRelatedFile(file);
                                },
                              );
                            }),
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
                );

                var comments = FutureBuilder<List<Comment>>(
                    future: DatabaseService(
                      uid: widget.project.uid,
                      subuid: widget.task.uid,
                    ).getComments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Loading();
                      }
                      snapshot.data
                          .sort((e1, e2) => e1.time.compareTo(e2.time));
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 30, bottom: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return _CommentPreview(
                              project: widget.project,
                              task: widget.task,
                              comment: snapshot.data[index],
                              onDelete: () {
                                DatabaseService(
                                        uid: widget.project.uid,
                                        subuid: widget.task.uid)
                                    .deleteComment(snapshot.data[index])
                                    .then((value) => setState(() {}));
                                if (snapshot.data[index].hasFiles) {
                                  inputFilesMeta.forEach((e) {
                                    CouldStorageService(
                                      projectUid: widget.project.uid,
                                      taskUid: widget.task.uid,
                                    )
                                        .deleteCommentFile(
                                            snapshot.data[index], e)
                                        .then((value) => setState(() {}));
                                  });
                                }
                              },
                            );
                          },
                        ),
                      );
                    });

                return Stack(fit: StackFit.expand, children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: 200.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      taskMainTextExpandable,
                      relatedFilesExpandable,
                      ExpansionTile(
                        title: Text("Комментарии"),
                        onExpansionChanged: (value) {
                          setState(() {
                            textInputVisibility = value;
                          });
                        },
                        children: [comments],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: textInputVisibility,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (inputFilesMeta.isNotEmpty)
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            alignment: Alignment.bottomLeft,
                            child: FilesList(
                              files: inputFilesMeta,
                              onFileDelete: (fileMeta) {
                                setState(() {
                                  inputFilesMeta.remove(fileMeta);
                                  if (inputFilesMeta.isNotEmpty) {
                                    hasFiles = true;
                                  } else {
                                    hasFiles = false;
                                  }
                                });
                              },
                            ),
                          ),
                        TextInput(
                          textMessageSubmitted: (message) async {
                            print(message);
                            var comment = new Comment(
                              message: message,
                              hasFiles: hasFiles,
                              userUid: (await AuthService().getUser).uid,
                            );
                            DatabaseService(
                                    uid: widget.project.uid,
                                    subuid: widget.task.uid)
                                .updateComment(comment)
                                .then((value) => setState(() {}));
                            if (comment.hasFiles) {
                              inputFilesMeta.forEach((e) {
                                CouldStorageService(
                                  projectUid: widget.project.uid,
                                  taskUid: widget.task.uid,
                                )
                                    .addCommentFile(comment, e.file)
                                    .then((value) => setState(() {
                                          inputFilesMeta.clear();
                                        }));
                              });
                              hasFiles = false;
                            }
                          },
                          addFileTap: () async {
                            File file =
                                await FilePicker.getFile(type: FileType.any);
                            FileMeta temp = FileMeta(
                              name: p.basename(file.path),
                            );
                            temp.file = file;
                            setState(() {
                              inputFilesMeta.add(temp);
                              if (inputFilesMeta.isNotEmpty) {
                                hasFiles = true;
                              } else {
                                hasFiles = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
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

class TextInput extends StatefulWidget {
  final void Function(String) textMessageSubmitted;
  final void Function() addFileTap;

  const TextInput({
    this.textMessageSubmitted,
    this.addFileTap,
  });

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _isComposingMessage = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: _isComposingMessage
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.assignment,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      widget.addFileTap();
                    },
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (text) {
                      setState(() {
                        text.length > 0
                            ? _isComposingMessage = true
                            : _isComposingMessage = false;
                      });
                    },
                    decoration: InputDecoration.collapsed(
                        hintText: "Отправить сообщение"),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        if (!_isComposingMessage) {
                          return;
                        }
                        widget.textMessageSubmitted(
                          _textEditingController.text.trim(),
                        );
                        _textEditingController.clear();
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentPreview extends StatefulWidget {
  final Project project;
  final Task task;
  final Comment comment;
  final void Function() onDelete;

  const _CommentPreview({
    this.project,
    this.task,
    this.comment,
    this.onDelete,
  });

  @override
  __CommentPreviewState createState() => __CommentPreviewState();
}

class __CommentPreviewState extends State<_CommentPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserPreview(
              comment: widget.comment,
              onDelete: () {
                widget.onDelete();
              }),
          if (widget.comment.hasFiles)
            ExpandableNotifier(
              child: Card(
                child: ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Закрепленные файлы",
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    expanded: StreamBuilder<List<FileMeta>>(
                      stream: CouldStorageService(
                        projectUid: widget.project.uid,
                        taskUid: widget.task.uid,
                      ).getCommentFilesMeta(widget.comment),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        }
                        return FilesList(
                          files: snapshot.data,
                          allowAdding: false,
                          allowDelete: false,
                          onFileTap: (fileMeta) async {
                            if (!(await isExist(context, fileMeta.name))) {
                              await CouldStorageService(
                                projectUid: widget.project.uid,
                                taskUid: widget.task.uid,
                              )
                                  .downloadFile(fileMeta)
                                  .then((_) => setState(() {}));
                            } else {
                              final dir =
                                  (await getExternalStorageDirectory()).path;
                              await OpenFile.open("$dir/${fileMeta.name}");
                            }
                          },
                          onFileDelete: (fileMeta) async {
                            await CouldStorageService(
                                    projectUid: widget.project.uid,
                                    taskUid: widget.task.uid)
                                .deleteCommentFile(widget.comment, fileMeta)
                                .then((_) => setState(() {}));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.comment.message,
              textAlign: TextAlign.left,
            ),
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
  final Comment comment;
  final void Function() onDelete;

  UserPreview({this.comment, this.onDelete});

  @override
  Widget build(BuildContext context) {
    bool myComment = false;
    return FutureBuilder<UserData>(
        future: DatabaseService().getUserData(comment.userUid),
        builder: (context, snapshot) {
          AuthService()
              .getUser
              .then((value) => myComment = comment.userUid == value.uid);
          if (!snapshot.hasData) {
            return Loading();
          }
          return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(),
            title: Text("${snapshot.data.displayName}"),
            subtitle: Text(
                "${snapshot.data.email}\n${DateFormat('yyyy-MM-dd - kk:mm').format(comment.time)}"),
            isThreeLine: true,
            trailing: Visibility(
              visible: myComment,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.mode_edit),
                  // ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => onDelete(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
