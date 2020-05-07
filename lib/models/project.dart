import 'dart:convert';
import 'dart:math';

import 'package:PTasker/models/task_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  static Random rng = new Random();

  final String uid;
  final String name;
  final String description;
  final String authorUid;
  final Map<String, bool> relatedUserUids;
  final List<Task> relatedTasks;
  final Map<String, int> color;
  final DateTime dateOfCreation;
  final DateTime dateOfCompletion;

  Project(
      {String uid,
      String name,
      String description,
      String authorUid,
      Map<String, bool> relatedUserUids,
      List<Task> relatedTasks,
      Map<String, int> color,
      DateTime dateOfCreation,
      DateTime dateOfCompletion})
      : this.uid = uid ?? Uuid().v4(),
        this.name = name ?? "Название проекта",
        this.description = description ?? 'Описание',
        this.authorUid = authorUid ?? null,
        this.relatedUserUids = relatedUserUids ?? Map<String, bool>(),
        this.relatedTasks = relatedTasks ?? List<Task>(),
        this.color = color ??
            {
              'r': rng.nextInt(255),
              'g': rng.nextInt(255),
              'b': rng.nextInt(255)
            },
        this.dateOfCreation = dateOfCreation ?? new DateTime.now().toUtc(),
        this.dateOfCompletion = dateOfCompletion;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$ProjectFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
