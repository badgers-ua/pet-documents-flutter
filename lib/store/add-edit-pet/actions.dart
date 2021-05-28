import '../index.dart';

class LoadAddEditPet extends AppAction {}

class LoadAddEditPetSuccess extends AppAction {
}

class LoadAddEditPetFailure extends AppAction {
  final String payload;

  LoadAddEditPetFailure({required this.payload});
}

class ClearAddEditPetState extends AppAction {
}
