import 'package:PTasker/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String uid;
  final String userUid;
  final String message;
  final DateTime time;

  @JsonKey(ignore: true)
  UserData user;

  Comment({this.uid, this.userUid, this.message, this.time});

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
