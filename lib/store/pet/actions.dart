import 'package:pdoc/models/dto/response/pet_res_dto.dart';

import '../index.dart';

class LoadPet extends AppAction {}

class LoadPetSuccess extends AppAction {
  final PetResDto payload;

  LoadPetSuccess({required this.payload});
}

class LoadPetFailure extends AppAction {
  final String payload;

  LoadPetFailure({required this.payload});
}

class ClearPetState extends AppAction {
}
