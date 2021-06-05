// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_pet_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePetReqDto _$CreatePetReqDtoFromJson(Map<String, dynamic> json) {
  return CreatePetReqDto(
    name: json['name'] as String,
    species: _$enumDecode(_$SPECIESEnumMap, json['species']),
    breed: json['breed'] as String?,
    gender: _$enumDecodeNullable(_$GENDEREnumMap, json['gender']),
    dateOfBirth: json['dateOfBirth'] as String?,
    colour: json['colour'] as String?,
    notes: json['notes'] as String?,
    weight: json['weight'] as int?,
    avatar: json['avatar'] as String?,
  );
}

Map<String, dynamic> _$CreatePetReqDtoToJson(CreatePetReqDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'species': _$SPECIESEnumMap[instance.species],
      'breed': instance.breed,
      'gender': _$GENDEREnumMap[instance.gender],
      'dateOfBirth': instance.dateOfBirth,
      'colour': instance.colour,
      'notes': instance.notes,
      'weight': instance.weight,
      'avatar': instance.avatar,
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

const _$SPECIESEnumMap = {
  SPECIES.CAT: 0,
  SPECIES.DOG: 1,
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$GENDEREnumMap = {
  GENDER.MALE: 0,
  GENDER.FEMALE: 1,
};
