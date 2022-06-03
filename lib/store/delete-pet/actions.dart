import '../index.dart';

class LoadDeletePet extends AppAction {}

class LoadDeletePetSuccess extends AppAction {
}

class LoadDeletePetFailure extends AppAction {
  final String payload;

  LoadDeletePetFailure({required this.payload});
}

class ClearDeletePetState extends AppAction {
}
