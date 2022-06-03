import 'package:json_annotation/json_annotation.dart';

part 'sign_in_res_dto.g.dart';

@JsonSerializable()
class SignInResDto {
  final String accessToken;
  final String refreshToken;
  final int expiresAt;

  SignInResDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory SignInResDto.fromJson(Map<String, dynamic> json) => _$SignInResDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SignInResDtoToJson(this);
}
