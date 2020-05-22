import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@JsonSerializable()
class Task {
  final String uid;
  final String title;
  final String mainText;
  final String authorUid;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dateOfCreation;
  final DateTime dateOfCompletion;
  final List<String> relatedUserUids;

  Task(
      {String uid,
      String title,
      String mainText,
      @required String authorUid,
      TaskPriority priority,
      TaskStatus status,
      DateTime dateOfCreation,
      DateTime dateOfCompletion,
      List<String> relatedUserUids})
      : this.uid = uid ?? Uuid().v4(),
        this.title = title ?? "Оглавние задачи",
        this.mainText = mainText ?? "Описание задачи",
        this.authorUid = authorUid,
        this.priority = priority ?? TaskPriority.medium,
        this.status = status ?? TaskStatus.open,
        this.dateOfCreation = dateOfCreation ?? DateTime.now().toUtc(),
        this.dateOfCompletion = dateOfCompletion ?? DateTime.now().toUtc(),
        this.relatedUserUids = relatedUserUids ?? List<String>();

  Task copy(
      {String title,
      String mainText,
      TaskPriority priority,
      TaskStatus status,
      DateTime dateOfCompletion,
      List<String> relatedUserUids}) {
    return Task(
        uid: this.uid,
        title: title ?? this.title,
        mainText: mainText ?? this.mainText,
        authorUid: this.authorUid,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        dateOfCreation: this.dateOfCreation,
        dateOfCompletion: dateOfCompletion ?? this.dateOfCompletion,
        relatedUserUids: relatedUserUids ?? this.relatedUserUids);
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TaskFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TaskToJson`.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
