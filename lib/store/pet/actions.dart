import 'package:pdoc/models/pet_state.dart';

import '../index.dart';

class LoadPet extends AppAction {}

class LoadPetSuccess extends AppAction {
  final Pet payload;

  LoadPetSuccess({required this.payload});
}

class LoadPetFailure extends AppAction {
  final String payload;

  LoadPetFailure({required this.payload});
}

class ClearPetState extends AppAction {
}
