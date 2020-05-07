// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    uid: json['uid'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    authorUid: json['authorUid'] as String,
    relatedUserUids: (json['relatedUserUids'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as bool),
    ),
    relatedTasks: (json['relatedTasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    color: (json['color'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    ),
    dateOfCreation: json['dateOfCreation'] == null
        ? null
        : DateTime.parse(json['dateOfCreation'] as String),
    dateOfCompletion: json['dateOfCompletion'] == null
        ? null
        : DateTime.parse(json['dateOfCompletion'] as String),
  );
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'authorUid': instance.authorUid,
      'relatedUserUids': instance.relatedUserUids,
      'relatedTasks': instance.relatedTasks.map((e) => e.toJson()).toList(),
      'color': instance.color,
      'dateOfCreation': instance.dateOfCreation?.toIso8601String(),
      'dateOfCompletion': instance.dateOfCompletion?.toIso8601String(),
    };
