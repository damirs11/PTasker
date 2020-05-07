// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    uid: json['uid'] as String,
    title: json['title'] as String,
    mainText: json['mainText'] as String,
    authorUid: json['authorUid'] as String,
    priority: _$enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
    status: _$enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
    dateOfCompletion: json['dateOfCompletion'] == null
        ? null
        : DateTime.parse(json['dateOfCompletion'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'mainText': instance.mainText,
      'authorUid': instance.authorUid,
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'status': _$TaskStatusEnumMap[instance.status],
      'dateOfCompletion': instance.dateOfCompletion?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};

const _$TaskStatusEnumMap = {
  TaskStatus.open: 'open',
  TaskStatus.taken: 'taken',
  TaskStatus.onApprove: 'onApprove',
  TaskStatus.closed: 'closed',
};
