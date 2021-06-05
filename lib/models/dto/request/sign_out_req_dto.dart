import 'package:json_annotation/json_annotation.dart';

part 'sign_out_req_dto.g.dart';

@JsonSerializable()
class SignOutReqDto {
  String deviceToken;

  SignOutReqDto({
    required this.deviceToken,
  });

  factory SignOutReqDto.fromJson(Map<String, dynamic> json) => _$SignOutReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignOutReqDtoToJson(this);
}
