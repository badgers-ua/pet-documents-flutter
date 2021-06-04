import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/request/sign_in_req_dto.dart';

part 'sign_up_req_dto.g.dart';

@JsonSerializable()
class SignUpReqDto extends SignInReqDto {
  final String firstName;
  final String lastName;

  SignUpReqDto({
    required this.firstName,
    required this.lastName,
    final email,
    final password,
    final deviceToken,
  }) : super(
          email: email,
          password: password,
          deviceToken: deviceToken,
        );

  factory SignUpReqDto.fromJson(Map<String, dynamic> json) => _$SignUpReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpReqDtoToJson(this);
}
