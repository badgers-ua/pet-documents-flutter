// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResDto _$UserResDtoFromJson(Map<String, dynamic> json) {
  return UserResDto(
    id: json['_id'],
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    avatar: json['avatar'],
  );
}

Map<String, dynamic> _$UserResDtoToJson(UserResDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatar': instance.avatar,
    };
