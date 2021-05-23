// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInReqDto _$SignInReqDtoFromJson(Map<String, dynamic> json) {
  return SignInReqDto(
    email: json['email'] as String,
    password: json['password'] as String,
    deviceToken: json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$SignInReqDtoToJson(SignInReqDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceToken': instance.deviceToken,
    };
