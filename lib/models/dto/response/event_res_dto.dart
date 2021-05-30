import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/l10n/l10n.dart';

part 'event_res_dto.g.dart';

String getEventLabel({
  required BuildContext ctx,
  required EVENT event,
}) {
  switch (event) {
    case EVENT.VACCINATION:
      return L10n.of(ctx).event_vaccination;
    case EVENT.DEWORMING:
      return L10n.of(ctx).event_deworming;
    case EVENT.END_OF_TREATMENT:
      return L10n.of(ctx).event_end_of_treatment;
    case EVENT.OPERATION:
      return L10n.of(ctx).event_operation;
    case EVENT.CHILDBIRTH:
      return L10n.of(ctx).event_childbirth;
    case EVENT.STERILIZATION:
      return L10n.of(ctx).event_sterilization;
    case EVENT.TICK_TREATMENT:
      return L10n.of(ctx).event_tick_treatment;
    case EVENT.VACCINATION_AGAINST_RABIES:
      return L10n.of(ctx).event_vaccination_against_rabies;
    case EVENT.VETERINARIAN_EXAMINATION:
      return L10n.of(ctx).event_veterinarian_examination;
    case EVENT.SHOW:
      return L10n.of(ctx).event_show;
    case EVENT.REWARD:
      return L10n.of(ctx).event_reward;
    case EVENT.PHOTO_SESSION:
      return L10n.of(ctx).event_photo_session;
    case EVENT.TRAINING:
      return L10n.of(ctx).event_training;
    case EVENT.START_OF_TREATMENT:
      return L10n.of(ctx).event_start_of_treatment;
    case EVENT.PAIRING:
      return L10n.of(ctx).event_pairing;
    case EVENT.ESTRUS:
      return L10n.of(ctx).event_estrus;
    case EVENT.MOLT:
      return L10n.of(ctx).event_molt;
    default:
      return '';
  }
}

enum EVENT {
  @JsonValue(0)
  VACCINATION,
  @JsonValue(1)
  DEWORMING,
  @JsonValue(2)
  TICK_TREATMENT,
  @JsonValue(3)
  VACCINATION_AGAINST_RABIES,
  @JsonValue(4)
  VETERINARIAN_EXAMINATION,
  @JsonValue(5)
  SHOW,
  @JsonValue(6)
  REWARD,
  @JsonValue(7)
  PHOTO_SESSION,
  @JsonValue(8)
  TRAINING,
  @JsonValue(9)
  START_OF_TREATMENT,
  @JsonValue(10)
  END_OF_TREATMENT,
  @JsonValue(11)
  OPERATION,
  @JsonValue(12)
  CHILDBIRTH,
  @JsonValue(13)
  STERILIZATION,
  @JsonValue(14)
  PAIRING,
  @JsonValue(15)
  ESTRUS,
  @JsonValue(16)
  MOLT,
}

@JsonSerializable()
class EventResDto {
  @JsonKey(name: '_id')
  final String id;
  final EVENT type;
  final String date;
  final String description;
  final bool isNotification;

  EventResDto({
    required this.id,
    required this.type,
    required this.date,
    required this.description,
    required this.isNotification,
  });

  factory EventResDto.fromJson(Map<String, dynamic> json) =>
      _$EventResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventResDtoToJson(this);
}
