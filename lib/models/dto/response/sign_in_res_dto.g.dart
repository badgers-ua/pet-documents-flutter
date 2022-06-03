// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResDto _$SignInResDtoFromJson(Map<String, dynamic> json) {
  return SignInResDto(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    expiresAt: json['expiresAt'] as int,
  );
}

Map<String, dynamic> _$SignInResDtoToJson(SignInResDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt,
    };
