import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/services/auth.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TaskEdit extends StatelessWidget {
  Project project;
  Task task;
  TaskEdit({this.project, this.task});

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pColor(project, 1),
      ),
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
                  'title': task?.title ?? '',
                  'mainText': task?.mainText ?? '',
                  'dateOfCreation': task?.dateOfCreation ?? DateTime.now(),
                  'dateOfCompletion': task?.dateOfCompletion ?? DateTime.now(),
                  'priority': task?.priority ?? TaskPriority.medium,
                },
                readOnly: false,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "title",
                      decoration: InputDecoration(
                        labelText: "Название задачи",
                      ),
                      onChanged: _onChanged,
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(60,
                            errorText: "Макс. 60 символов")
                      ],
                      keyboardType: TextInputType.multiline,
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
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      // initialValue: DateTime.now(),
                      // readonly: true,
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
                    FormBuilderRadio(
                      decoration:
                          InputDecoration(labelText: 'Приоритет задачи'),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      attribute: "priority",
                      options: [
                        FormBuilderFieldOption(
                          value: TaskPriority.low,
                          child: Text('Низкий'),
                        ),
                        FormBuilderFieldOption(
                          value: TaskPriority.medium,
                          child: Text('Средний'),
                        ),
                        FormBuilderFieldOption(
                          value: TaskPriority.high,
                          child: Text('Высокий'),
                        ),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "mainText",
                      decoration: InputDecoration(
                        labelText: "Описание задачи",
                      ),
                      onChanged: _onChanged,
                      // valueTransformer: (text) => num.tryParse(text),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: pColor(project, 1),
                      child: Text(
                        "Сохранить",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);

                          User author = await AuthService().getUser;
                          Task newTask;

                          if (task != null) {
                            newTask = task.copy(
                              title: _fbKey.currentState.value['title'],
                              mainText: _fbKey.currentState.value['mainText'],
                              priority: _fbKey.currentState.value['priority'],
                              dateOfCompletion:
                                  _fbKey.currentState.value['dateOfCompletion'],
                            );
                          } else {
                            newTask = new Task(
                              authorUid: author.uid,
                            );

                            newTask = newTask.copy(
                              title: _fbKey.currentState.value['title'],
                              mainText: _fbKey.currentState.value['mainText'],
                              priority: _fbKey.currentState.value['priority'],
                              dateOfCompletion:
                                  _fbKey.currentState.value['dateOfCompletion'],
                            );
                          }

                          DatabaseService().updateTask(project, newTask);
                          Navigator.pop(context);
                        } else {
                          print(_fbKey.currentState.value);
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
                      color: pColor(project, 0.8),
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
