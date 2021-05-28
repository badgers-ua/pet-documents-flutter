import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';

part 'create_pet_req_dto.g.dart';

@JsonSerializable()
class CreatePetReqDto {
  final String name;
  final SPECIES species;
  late String? breed;
  late GENDER? gender;
  late String? dateOfBirth; // ISO String;
  late String? colour;
  late String? notes;

  CreatePetReqDto({
    required this.name,
    required this.species,
    this.breed,
    this.gender,
    this.dateOfBirth,
    this.colour,
    this.notes,
  });

  factory CreatePetReqDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePetReqDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePetReqDtoToJson(this);
}
