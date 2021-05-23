// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenReqDto _$RefreshTokenReqDtoFromJson(Map<String, dynamic> json) {
  return RefreshTokenReqDto(
    refreshToken: json['refreshToken'] as String,
    deviceToken: json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$RefreshTokenReqDtoToJson(RefreshTokenReqDto instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceToken': instance.deviceToken,
    };
