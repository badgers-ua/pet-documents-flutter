import 'package:pdoc/models/dto/response/user_res_dto.dart';

import '../index.dart';

class LoadUser extends AppAction {}

class LoadUserSuccess extends AppAction {
  final UserResDto payload;

  LoadUserSuccess({required this.payload});
}

class LoadUserFailure extends AppAction {
  final String payload;

  LoadUserFailure({required this.payload});
}

class ClearUserState extends AppAction {
}
