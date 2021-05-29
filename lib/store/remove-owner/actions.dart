import '../index.dart';

class LoadRemoveOwner extends AppAction {}

class LoadRemoveOwnerSuccess extends AppAction {
}

class LoadRemoveOwnerFailure extends AppAction {
  final String payload;

  LoadRemoveOwnerFailure({required this.payload});
}

class ClearRemoveOwnerState extends AppAction {
}
