import 'package:json_annotation/json_annotation.dart';

part 'social_sign_in_req_dto.g.dart';

enum SOCIAL_TYPE {
  @JsonValue(0)
  APPLE,
  @JsonValue(1)
  FACEBOOK,
  @JsonValue(2)
  GOOGLE,
}

enum PLATFORM {
  @JsonValue(0)
  ANDROID,
  @JsonValue(1)
  IOS,
  @JsonValue(2)
  WEB,
}

PLATFORM? getPlatformByPlatformName({required String osName}) {
  switch (osName) {
    case 'android':
      return PLATFORM.ANDROID;
    case 'ios':
      return PLATFORM.IOS;
  }
}

@JsonSerializable()
class SocialSignInReqDto {
  final String token;
  final SOCIAL_TYPE socialType;
  final String email;
  final String firstName;
  final String lastName;
  final String deviceToken;
  final PLATFORM platform;
  final String avatar;

  SocialSignInReqDto({
    required this.token,
    required this.socialType,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.deviceToken,
    required this.platform,
    required this.avatar,
  });

  factory SocialSignInReqDto.fromJson(Map<String, dynamic> json) => _$SocialSignInReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SocialSignInReqDtoToJson(this);
}
