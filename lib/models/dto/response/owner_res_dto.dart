import 'package:json_annotation/json_annotation.dart';

part 'owner_res_dto.g.dart';

@JsonSerializable()
class OwnerResDto {
  final String userId;
  final String email;
  final String? phoneNumber;
  final String? familyName;
  final String? givenName;

  OwnerResDto({
    required this.userId,
    required this.email,
    this.phoneNumber,
    this.familyName,
    this.givenName,
  });

  factory OwnerResDto.fromJson(Map<String, dynamic> json) => _$OwnerResDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerResDtoToJson(this);
}
