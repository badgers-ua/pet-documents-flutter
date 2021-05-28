import 'package:json_annotation/json_annotation.dart';

part 'create_pet_res_dto.g.dart';

@JsonSerializable()
class CreatePetResDto {
  @JsonKey(name: '_id')
  final String id;

  CreatePetResDto({
    required this.id,
  });

  factory CreatePetResDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePetResDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePetResDtoToJson(this);
}
