import '../index.dart';

class LoadAddOwner extends AppAction {}

class LoadAddOwnerSuccess extends AppAction {
}

class LoadAddOwnerFailure extends AppAction {
  final String payload;

  LoadAddOwnerFailure({required this.payload});
}

class ClearAddOwnerState extends AppAction {
}
