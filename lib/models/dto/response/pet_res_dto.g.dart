// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetPreviewResDto _$PetPreviewResDtoFromJson(Map<String, dynamic> json) {
  return PetPreviewResDto(
    breed: json['breed'] as String?,
    owners: (json['owners'] as List<dynamic>).map((e) => e as String?).toList(),
    id: json['_id'],
    name: json['name'],
    species: _$enumDecode(_$SPECIESEnumMap, json['species']),
    gender: _$enumDecodeNullable(_$GENDEREnumMap, json['gender']),
    dateOfBirth: json['dateOfBirth'],
    colour: json['colour'],
    notes: json['notes'],
  );
}

Map<String, dynamic> _$PetPreviewResDtoToJson(PetPreviewResDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'species': _$SPECIESEnumMap[instance.species],
      'gender': _$GENDEREnumMap[instance.gender],
      'dateOfBirth': instance.dateOfBirth,
      'colour': instance.colour,
      'notes': instance.notes,
      'breed': instance.breed,
      'owners': instance.owners,
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

PetResDto _$PetResDtoFromJson(Map<String, dynamic> json) {
  return PetResDto(
    breed: json['breed'] == null
        ? null
        : StaticResDto.fromJson(json['breed'] as Map<String, dynamic>),
    owners: (json['owners'] as List<dynamic>)
        .map((e) => OwnerResDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    id: json['_id'],
    name: json['name'],
    species: _$enumDecode(_$SPECIESEnumMap, json['species']),
    gender: _$enumDecodeNullable(_$GENDEREnumMap, json['gender']),
    dateOfBirth: json['dateOfBirth'],
    colour: json['colour'],
    notes: json['notes'],
  );
}

Map<String, dynamic> _$PetResDtoToJson(PetResDto instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'species': _$SPECIESEnumMap[instance.species],
      'gender': _$GENDEREnumMap[instance.gender],
      'dateOfBirth': instance.dateOfBirth,
      'colour': instance.colour,
      'notes': instance.notes,
      'breed': instance.breed?.toJson(),
      'owners': instance.owners.map((e) => e.toJson()).toList(),
    };
