import 'package:dio/dio.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';

class EditPetReqDto extends CreatePetReqDto {
  bool isAvatarChanged;

  EditPetReqDto({
    required name,
    required species,
    breed,
    gender,
    dateOfBirth,
    colour,
    notes,
    weight,
    avatar,
    this.isAvatarChanged = false,
  }) : super(
          name: name,
          species: species,
          breed: breed,
          gender: gender,
          dateOfBirth: dateOfBirth,
          colour: colour,
          notes: notes,
          weight: weight,
          avatar: avatar,
        );
  
  static EditPetReqDto fromCreatePetReqDto({required CreatePetReqDto dto, required bool isAvatarChanged}) {
    return EditPetReqDto(
        name: dto.name,
        species: dto.species,
        breed: dto.breed,
        weight: dto.weight,
        notes: dto.notes,
        colour: dto.colour,
        dateOfBirth: dto.dateOfBirth,
        gender: dto.gender,
        isAvatarChanged: isAvatarChanged,
        avatar: isAvatarChanged ? dto.avatar : null,
    );
  }

  Future<FormData> toFormData() async {
    final FormData formData = await super.toFormData();
    formData.fields.add(MapEntry('isAvatarChanged', this.isAvatarChanged.toString()));
    return formData;
  }
}
