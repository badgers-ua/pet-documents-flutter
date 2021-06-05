import '../index.dart';

class LoadSignOut extends AppAction {}

class LoadSignOutSuccess extends AppAction {
}

class LoadSignOutFailure extends AppAction {
  final String payload;

  LoadSignOutFailure({required this.payload});
}

class ClearSignOutState extends AppAction {
}
