import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

part 'event_req_dto.g.dart';

@JsonSerializable()
class EventReqDto {
  final String pet;
  final EVENT type;
  final String date;
  final String description;
  final bool isNotification;

  EventReqDto({
    required this.pet,
    required this.type,
    required this.date,
    required this.description,
    required this.isNotification,
  });

  factory EventReqDto.fromJson(Map<String, dynamic> json) =>
      _$EventReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventReqDtoToJson(this);
}
