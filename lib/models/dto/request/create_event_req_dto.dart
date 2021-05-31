import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

part 'create_event_req_dto.g.dart';

@JsonSerializable()
class CreateEventReqDto {
  final String petId;
  final EVENT type;
  final String date;
  late String? description;
  final bool isNotification;

  CreateEventReqDto({
    required this.petId,
    required this.type,
    required this.date,
    required this.isNotification,
    this.description,
  });

  factory CreateEventReqDto.fromJson(Map<String, dynamic> json) =>
      _$CreateEventReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventReqDtoToJson(this);
}
