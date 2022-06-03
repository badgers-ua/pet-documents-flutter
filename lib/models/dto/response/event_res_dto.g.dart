// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResDto _$EventResDtoFromJson(Map<String, dynamic> json) {
  return EventResDto(
    id: json['_id'] as String,
    type: _$enumDecode(_$EVENTEnumMap, json['type']),
    date: json['date'] as String,
    petId: json['petId'] as String,
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$EventResDtoToJson(EventResDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': _$EVENTEnumMap[instance.type],
      'date': instance.date,
      'petId': instance.petId,
      'description': instance.description,
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
