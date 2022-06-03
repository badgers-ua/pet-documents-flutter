import '../index.dart';

class LoadEditEvent extends AppAction {}

class LoadEditEventSuccess extends AppAction {
}

class LoadEditEventFailure extends AppAction {
  final String payload;

  LoadEditEventFailure({required this.payload});
}

class ClearEditEventState extends AppAction {
}
