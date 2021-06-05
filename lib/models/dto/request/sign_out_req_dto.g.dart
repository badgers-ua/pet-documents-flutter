// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_out_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignOutReqDto _$SignOutReqDtoFromJson(Map<String, dynamic> json) {
  return SignOutReqDto(
    deviceToken: json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$SignOutReqDtoToJson(SignOutReqDto instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
    };
