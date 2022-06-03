import '../index.dart';

class LoadEditPet extends AppAction {}

class LoadEditPetSuccess extends AppAction {
}

class LoadEditPetFailure extends AppAction {
  final String payload;

  LoadEditPetFailure({required this.payload});
}

class ClearEditPetState extends AppAction {
}
