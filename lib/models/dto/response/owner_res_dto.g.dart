// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerResDto _$OwnerResDtoFromJson(Map<String, dynamic> json) {
  return OwnerResDto(
    id: json['_id'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$OwnerResDtoToJson(OwnerResDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatar': instance.avatar,
    };
