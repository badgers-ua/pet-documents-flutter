import 'package:json_annotation/json_annotation.dart';

part 'remove_owner_req_dto.g.dart';

@JsonSerializable()
class RemoveOwnerReqDto {
  String ownerId;

  RemoveOwnerReqDto({required this.ownerId});

  factory RemoveOwnerReqDto.fromJson(Map<String, dynamic> json) =>
      _$RemoveOwnerReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveOwnerReqDtoToJson(this);
}
