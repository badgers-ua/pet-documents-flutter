import '../index.dart';

class LoadDeleteEvent extends AppAction {}

class LoadDeleteEventSuccess extends AppAction {}

class LoadDeleteEventFailure extends AppAction {
  final String payload;

  LoadDeleteEventFailure({required this.payload});
}

class ClearDeleteEventState extends AppAction {}
