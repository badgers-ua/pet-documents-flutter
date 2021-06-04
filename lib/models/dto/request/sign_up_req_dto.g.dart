// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpReqDto _$SignUpReqDtoFromJson(Map<String, dynamic> json) {
  return SignUpReqDto(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'],
    password: json['password'],
    deviceToken: json['deviceToken'],
  );
}

Map<String, dynamic> _$SignUpReqDtoToJson(SignUpReqDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceToken': instance.deviceToken,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
