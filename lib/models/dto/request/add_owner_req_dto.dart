import 'package:json_annotation/json_annotation.dart';

part 'add_owner_req_dto.g.dart';

@JsonSerializable()
class AddOwnerReqDto {
  String ownerEmail;

  AddOwnerReqDto({required this.ownerEmail});

  factory AddOwnerReqDto.fromJson(Map<String, dynamic> json) =>
      _$AddOwnerReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddOwnerReqDtoToJson(this);
}
