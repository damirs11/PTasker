// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMeta _$FileMetaFromJson(Map<String, dynamic> json) {
  return FileMeta(
    uid: json['uid'] as String,
    url: json['url'] as String,
    name: json['name'] as String,
    storagePath: json['storagePath'] as String,
  );
}

Map<String, dynamic> _$FileMetaToJson(FileMeta instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'storagePath': instance.storagePath,
      'url': instance.url,
    };
