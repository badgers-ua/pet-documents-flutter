import 'package:json_annotation/json_annotation.dart';

part 'sign_in_req_dto.g.dart';

@JsonSerializable()
class SignInReqDto {
  String email;
  String password;
  String deviceToken;

  SignInReqDto({
    required this.email,
    required this.password,
    required this.deviceToken,
  });

  factory SignInReqDto.fromJson(Map<String, dynamic> json) => _$SignInReqDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SignInReqDtoToJson(this);
}
