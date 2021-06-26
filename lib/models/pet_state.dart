import 'package:pdoc/models/dto/response/pet_res_dto.dart';

class Pet {
  final PetResDto? petResDto;
  final String avatarUrl;

  Pet({
    required this.petResDto,
    required this.avatarUrl,
  });
}