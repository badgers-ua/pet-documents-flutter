// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateEventReqDto _$CreateEventReqDtoFromJson(Map<String, dynamic> json) {
  return CreateEventReqDto(
    petId: json['petId'] as String,
    type: _$enumDecode(_$EVENTEnumMap, json['type']),
    date: json['date'] as String,
    isNotification: json['isNotification'] as bool,
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$CreateEventReqDtoToJson(CreateEventReqDto instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'type': _$EVENTEnumMap[instance.type],
      'date': instance.date,
      'description': instance.description,
      'isNotification': instance.isNotification,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$EVENTEnumMap = {
  EVENT.VACCINATION: 0,
  EVENT.DEWORMING: 1,
  EVENT.TICK_TREATMENT: 2,
  EVENT.VACCINATION_AGAINST_RABIES: 3,
  EVENT.VETERINARIAN_EXAMINATION: 4,
  EVENT.SHOW: 5,
  EVENT.REWARD: 6,
  EVENT.PHOTO_SESSION: 7,
  EVENT.TRAINING: 8,
  EVENT.START_OF_TREATMENT: 9,
  EVENT.END_OF_TREATMENT: 10,
  EVENT.OPERATION: 11,
  EVENT.CHILDBIRTH: 12,
  EVENT.STERILIZATION: 13,
  EVENT.PAIRING: 14,
  EVENT.ESTRUS: 15,
  EVENT.MOLT: 16,
};
