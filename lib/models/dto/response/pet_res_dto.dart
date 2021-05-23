import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/response/owner_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';

part 'pet_res_dto.g.dart';

enum GENDER {
  @JsonValue(0)
  MALE,
  @JsonValue(1)
  FEMALE,
}

enum SPECIES {
  @JsonValue(0)
  CAT,
  @JsonValue(1)
  DOG,
}

abstract class _PetCommon {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final SPECIES species;
  final GENDER? gender;
  final String? dateOfBirth;
  final String? colour;
  final String? notes;

  _PetCommon({
    required this.id,
    required this.name,
    required this.species,
    this.gender,
    this.dateOfBirth,
    this.colour,
    this.notes,
  });
}

@JsonSerializable()
class PetPreviewResDto extends _PetCommon {
  final String? breed;
  final List<String?> owners;

  PetPreviewResDto({
    this.breed,
    required this.owners,
    required id,
    required name,
    required SPECIES species,
    GENDER? gender,
    dateOfBirth,
    colour,
    notes,
  }) : super(
          id: id,
          name: name,
          species: species,
          gender: gender,
          dateOfBirth: dateOfBirth,
          colour: colour,
          notes: notes,
        );

  factory PetPreviewResDto.fromJson(Map<String, dynamic> json) =>
      _$PetPreviewResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PetPreviewResDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PetResDto extends _PetCommon {
  final StaticResDto? breed;
  final List<OwnerResDto> owners;

  PetResDto({
    this.breed,
    required this.owners,
    required id,
    required name,
    required SPECIES species,
    GENDER? gender,
    dateOfBirth,
    colour,
    notes,
  }) : super(
          id: id,
          name: name,
          species: species,
          gender: gender,
          dateOfBirth: dateOfBirth,
          colour: colour,
          notes: notes,
        );

  factory PetResDto.fromJson(Map<String, dynamic> json) =>
      _$PetResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PetResDtoToJson(this);
}
