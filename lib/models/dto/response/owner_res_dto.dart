import 'package:json_annotation/json_annotation.dart';

part 'owner_res_dto.g.dart';

@JsonSerializable()
class OwnerResDto {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  OwnerResDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory OwnerResDto.fromJson(Map<String, dynamic> json) =>
      _$OwnerResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerResDtoToJson(this);
}
