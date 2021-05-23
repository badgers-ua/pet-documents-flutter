import 'package:pdoc/models/dto/response/pet_res_dto.dart';

import '../index.dart';

class LoadPets extends AppAction {}

class LoadPetsSuccess extends AppAction {
  final List<PetPreviewResDto> payload;

  LoadPetsSuccess({required this.payload});
}

class LoadPetsFailure extends AppAction {
  final String payload;

  LoadPetsFailure({required this.payload});
}

class ClearPetsState extends AppAction {}
