import 'dart:convert';
import 'dart:math';

import 'package:PTasker/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final Map<String, int> color;
  final DateTime dateOfCreation;
  final DateTime dateOfCompletion;

  Project(
      {String uid,
      String name,
      String description,
      @required String authorUid,
      Map<String, bool> relatedUserUids,
      Map<String, int> color,
      DateTime dateOfCreation,
      DateTime dateOfCompletion})
      : this.uid = uid ?? Uuid().v4(),
        this.name = name ?? "Название проекта",
        this.description = description ?? 'Описание',
        this.authorUid = authorUid ?? null,
        this.relatedUserUids = relatedUserUids ?? Map<String, bool>(),
        this.color = color ??
            {
              'r': rng.nextInt(255),
              'g': rng.nextInt(255),
              'b': rng.nextInt(255)
            },
        this.dateOfCreation = dateOfCreation ?? new DateTime.now().toUtc(),
        this.dateOfCompletion = dateOfCompletion ?? new DateTime.now().toUtc();

  Project copy(
      {String uid,
      String name,
      String description,
      @required String authorUid,
      Map<String, bool> relatedUserUids,
      Map<String, int> color,
      @required DateTime dateOfCreation,
      DateTime dateOfCompletion}) {
    return Project(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        description: description ?? this.description,
        authorUid: authorUid ?? this.authorUid,
        relatedUserUids: relatedUserUids ?? this.relatedUserUids,
        color: color ?? this.color,
        dateOfCreation: dateOfCreation ?? this.dateOfCreation,
        dateOfCompletion: dateOfCompletion ?? this.dateOfCompletion);
  }

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
