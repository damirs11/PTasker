// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    uid: json['uid'] as String,
    displayName: json['displayName'] as String,
    photoUrl: json['photoUrl'] as String,
    email: json['email'] as String,
    isAdmin: json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
    };
