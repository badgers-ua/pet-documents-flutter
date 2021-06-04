import '../index.dart';

class LoadSignUp extends AppAction {}

class LoadSignUpSuccess extends AppAction {
}

class LoadSignUpFailure extends AppAction {
  final String payload;

  LoadSignUpFailure({required this.payload});
}

class ClearSignUpState extends AppAction {}
