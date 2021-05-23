import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_req_dto.g.dart';

@JsonSerializable()
class RefreshTokenReqDto {
  final String refreshToken;
  final String deviceToken;

  RefreshTokenReqDto({
    required this.refreshToken,
    required this.deviceToken,
  });

  factory RefreshTokenReqDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenReqDtoToJson(this);
}
