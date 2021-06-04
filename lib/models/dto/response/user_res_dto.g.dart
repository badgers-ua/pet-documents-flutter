// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResDto _$UserResDtoFromJson(Map<String, dynamic> json) {
  return UserResDto(
    isEmailConfirmed: json['isEmailConfirmed'] as bool,
    id: json['_id'],
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
  );
}

Map<String, dynamic> _$UserResDtoToJson(UserResDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isEmailConfirmed': instance.isEmailConfirmed,
    };
