import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:http_parser/src/media_type.dart';

class CreatePetReqDto {
  final String name;
  final SPECIES species;
  late String? breed;
  late GENDER? gender;
  late String? dateOfBirth; // ISO String;
  late String? colour;
  late String? notes;
  late double? weight;
  late File? avatar;

  CreatePetReqDto({
    required this.name,
    required this.species,
    this.breed,
    this.gender,
    this.dateOfBirth,
    this.colour,
    this.notes,
    this.weight,
    this.avatar,
  });

  Future<FormData> toFormData() async {
    final FormData formData = FormData.fromMap({
      'name': this.name,
      'species': this.species.index.toString(),
      'breed': this.breed,
      'gender': this.gender?.index.toString(),
      'dateOfBirth': this.dateOfBirth, // ISO String;
      'colour': this.colour,
      'notes': this.notes,
      'weight': this.weight?.toString(),
      'avatar': this.avatar != null
          ? await MultipartFile.fromFile(
              this.avatar!.path,
              contentType: MediaType(
                'image',
                this.avatar!.path.split('.').last,
              ),
            )
          : null,
    });
    return formData;
  }
}
