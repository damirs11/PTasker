import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'file_meta.g.dart';

@JsonSerializable()
class FileMeta {
  final String uid;
  final String name;
  final String storagePath;
  final String url;

  @JsonKey(ignore: true)
  File file;

  FileMeta({String uid, this.url, this.name, this.storagePath})
      : this.uid = uid ?? Uuid().v4();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$FileMetaFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory FileMeta.fromJson(Map<String, dynamic> json) =>
      _$FileMetaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FileMetaToJson(this);
}
