import 'package:PTasker/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String uid;
  final String userUid;
  final String message;
  final DateTime time;
  final bool hasFiles;

  @JsonKey(ignore: true)
  DocumentReference user;

  Comment(
      {this.userUid, this.message, this.hasFiles, String uid, DateTime time})
      : this.uid = uid ?? Uuid().v4(),
        this.time = time ?? DateTime.now().toUtc();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$CommentFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$CommentToJson`.
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
