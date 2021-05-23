import 'package:json_annotation/json_annotation.dart';

part 'static_res_dto.g.dart';

@JsonSerializable()
class StaticResDto {
  final String id;
  final String name;

  StaticResDto({
    required this.id,
    required this.name,
  });

  factory StaticResDto.fromJson(Map<String, dynamic> json) => _$StaticResDtoFromJson(json);
  Map<String, dynamic> toJson() => _$StaticResDtoToJson(this);
}
