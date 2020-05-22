import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

class User {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;

  User({this.displayName, this.photoUrl, this.email, this.uid});
}

@JsonSerializable()
class UserData {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final bool isAdmin;

  UserData(
      {this.uid, String displayName, String photoUrl, this.email, bool isAdmin})
      : this.displayName = displayName ?? uid,
        this.photoUrl = photoUrl ?? null,
        this.isAdmin = isAdmin ?? false;

  //     Task copy(
  //   {String title,
  //   String mainText,
  //   TaskPriority priority,
  //   TaskStatus status}) {
  // return Task(
  //     uid: this.uid,
  //     title: title ?? this.title,
  //     mainText: mainText ?? this.mainText,
  //     authorUid: this.authorUid,
  //     priority: priority ?? this.priority,
  //     status: status ?? this.status);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
