import '../index.dart';

class LoadAddPet extends AppAction {}

class LoadAddPetSuccess extends AppAction {
}

class LoadAddPetFailure extends AppAction {
  final String payload;

  LoadAddPetFailure({required this.payload});
}

class ClearAddPetState extends AppAction {
}
