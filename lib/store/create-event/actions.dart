import '../index.dart';

class LoadCreateEvent extends AppAction {}

class LoadCreateEventSuccess extends AppAction {
}

class LoadCreateEventFailure extends AppAction {
  final String payload;

  LoadCreateEventFailure({required this.payload});
}

class ClearCreateEventState extends AppAction {
}
