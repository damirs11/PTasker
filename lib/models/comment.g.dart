// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    userUid: json['userUid'] as String,
    message: json['message'] as String,
    hasFiles: json['hasFiles'] as bool,
    uid: json['uid'] as String,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'uid': instance.uid,
      'userUid': instance.userUid,
      'message': instance.message,
      'time': instance.time?.toIso8601String(),
      'hasFiles': instance.hasFiles,
    };
