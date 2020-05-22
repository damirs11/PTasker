import 'dart:developer';

import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/services/auth.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectEditCreate extends StatefulWidget {
  Project project;
  ProjectEditCreate({this.project});

  @override
  _ProjectEditCreateState createState() => _ProjectEditCreateState();
}

class _ProjectEditCreateState extends State<ProjectEditCreate> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  ValueChanged _onChanged = (val) => print(val);

  Map<String, bool> relatedUsers;

  @override
  Widget build(BuildContext context) {
    relatedUsers = widget.project?.relatedUserUids ?? Map<String, bool>();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                // autovalidate: true,
                initialValue: {
                  'name': widget.project?.name ?? '',
                  'color': widget.project != null
                      ? pColor(widget.project, 1)
                      : Colors.amber,
                  'dateOfCreation':
                      widget.project?.dateOfCreation ?? DateTime.now(),
                  'dateOfCompletion':
                      widget.project?.dateOfCompletion ?? DateTime.now(),
                  'description': widget.project?.description ?? '',
                  // final String description;
                },
                readOnly: false,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "name",
                      decoration: InputDecoration(
                        labelText: "Название задачи",
                      ),
                      onChanged: _onChanged,
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(40,
                            errorText: "Макс. 40 символов")
                      ],
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderColorPicker(
                      attribute: 'color',
                      colorPickerType: ColorPickerType.SlidePicker,
                      decoration: InputDecoration(labelText: "Pick Color"),
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "dateOfCreation",
                      onChanged: _onChanged,
                      readOnly: true,
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: "Дата создания",
                      ),
                      validator: (val) => null,
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "dateOfCompletion",
                      onChanged: _onChanged,
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: "До какого сдать",
                      ),
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      decoration: InputDecoration(
                        labelText: "Описание задачи",
                      ),
                      onChanged: _onChanged,
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      keyboardType: TextInputType.multiline,
                    ),
                    StreamBuilder<User>(
                        stream: AuthService().user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return UserSelector(
                                authorUid: widget.project?.authorUid ??
                                    snapshot.data.uid,
                                relatedUsers: relatedUsers);
                          } else {
                            return Loading();
                          }
                        }),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Colors.green,
                      child: Text(
                        "Сохранить",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                          print(relatedUsers);

                          Map<String, int> color = {
                            'r': (_fbKey.currentState.value['color'] as Color)
                                .red,
                            'g': (_fbKey.currentState.value['color'] as Color)
                                .green,
                            'b': (_fbKey.currentState.value['color'] as Color)
                                .blue,
                          };

                          User author = await AuthService().getUser;
                          Project project;

                          if (widget.project != null) {
                            project = widget.project.copy(
                                name: _fbKey.currentState.value['name'],
                                color: color,
                                dateOfCreation:
                                    _fbKey.currentState.value['dateOfCreation'],
                                dateOfCompletion: _fbKey
                                    .currentState.value['dateOfCompletion'],
                                description:
                                    _fbKey.currentState.value['description'],
                                relatedUserUids: relatedUsers);
                          } else {
                            project = new Project(
                              authorUid: author.uid,
                            );
                            project = project.copy(
                              name: _fbKey.currentState.value['name'],
                              color: color,
                              dateOfCreation:
                                  _fbKey.currentState.value['dateOfCreation'],
                              dateOfCompletion:
                                  _fbKey.currentState.value['dateOfCompletion'],
                              description:
                                  _fbKey.currentState.value['description'],
                              relatedUserUids: relatedUsers,
                            );
                          }

                          DatabaseService().updateProject(project);
                          Navigator.pop(context, project);
                        } else {
                          print(_fbKey.currentState.value);
                          print(relatedUsers);
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: MaterialButton(
                      color: Colors.red,
                      child: Text(
                        "Сброс",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserSelector extends StatefulWidget {
  final String authorUid;
  Map<String, bool> relatedUsers;
  UserSelector({this.authorUid, var relatedUsers})
      : this.relatedUsers = relatedUsers ?? new Map<String, bool>();

  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  @override
  Widget build(BuildContext context) {
    List<bool> isSelected(Map<String, bool> relatedUsers, String userUid) {
      bool isFound = relatedUsers.containsKey(userUid);
      if (isFound) {
        return [true, relatedUsers['userUid']];
      }
      return [false, false];
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: false,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Кто учавствует?",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                collapsed: Text(
                  "loremIpsum",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: FutureBuilder<List<UserData>>(
                  initialData: List<UserData>(),
                  future: DatabaseService().usersData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      snapshot.data
                          .removeWhere((e) => e.uid == widget.authorUid);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: snapshot.data.map((user) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: user.photoUrl != null
                                  ? CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage:
                                          NetworkImage(user.photoUrl),
                                    )
                                  : CircleAvatar(
                                      radius: 20.0,
                                    ),
                              title: Text(user.displayName),
                              subtitle: Text(
                                user.uid.substring(0, 10) + "...",
                                overflow: TextOverflow.clip,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (widget.relatedUsers
                                          .containsKey(user.uid) &&
                                      !widget.relatedUsers[user.uid])
                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.arrowUp),
                                      onPressed: () {
                                        setState(() {
                                          widget.relatedUsers[user.uid] =
                                              !widget.relatedUsers[user.uid];
                                        });
                                      },
                                    ),
                                  if (widget.relatedUsers
                                          .containsKey(user.uid) &&
                                      widget.relatedUsers[user.uid])
                                    IconButton(
                                      icon: FaIcon(FontAwesomeIcons.arrowDown),
                                      onPressed: () {
                                        setState(() {
                                          widget.relatedUsers[user.uid] =
                                              !widget.relatedUsers[user.uid];
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: widget.relatedUsers
                                            .containsKey(user.uid)
                                        ? Icon(Icons.delete)
                                        : Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        if (!widget.relatedUsers
                                            .containsKey(user.uid)) {
                                          widget.relatedUsers.putIfAbsent(
                                              user.uid, () => false);
                                        } else {
                                          widget.relatedUsers.remove(user.uid);
                                        }

                                        widget.relatedUsers
                                            .forEach((key, value) {
                                          log(key + ": " + value.toString());
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(growable: false),
                      );
                    } else {
                      return Loading();
                    }
                  },
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
