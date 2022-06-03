// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_sign_in_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialSignInReqDto _$SocialSignInReqDtoFromJson(Map<String, dynamic> json) {
  return SocialSignInReqDto(
    token: json['token'] as String,
    socialType: _$enumDecode(_$SOCIAL_TYPEEnumMap, json['socialType']),
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    deviceToken: json['deviceToken'] as String,
    platform: _$enumDecode(_$PLATFORMEnumMap, json['platform']),
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$SocialSignInReqDtoToJson(SocialSignInReqDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'socialType': _$SOCIAL_TYPEEnumMap[instance.socialType],
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'deviceToken': instance.deviceToken,
      'platform': _$PLATFORMEnumMap[instance.platform],
      'avatar': instance.avatar,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$SOCIAL_TYPEEnumMap = {
  SOCIAL_TYPE.APPLE: 0,
  SOCIAL_TYPE.FACEBOOK: 1,
  SOCIAL_TYPE.GOOGLE: 2,
};

const _$PLATFORMEnumMap = {
  PLATFORM.ANDROID: 0,
  PLATFORM.IOS: 1,
  PLATFORM.WEB: 2,
};
