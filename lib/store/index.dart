import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/pet/reducers.dart';
import 'package:pdoc/store/pets/reducers.dart';
import 'package:pdoc/store/user/reducers.dart';

import 'auth/reducers.dart';
import 'device_token/reducers.dart';

abstract class AppAction {
  String toString() {
    return '$runtimeType';
  }
}

class RootState {
  final AuthState auth;
  final AppState<DeviceToken> deviceToken;
  final AppState<List<PetPreviewResDto>> pets;
  final AppState<PetResDto> pet;
  final AppState<UserResDto> user;

  RootState({
    required this.auth,
    required this.deviceToken,
    required this.pets,
    required this.pet,
    required this.user,
  });

  RootState.initialState()
      : auth = AuthState(isLoadingAccessToken: true),
        deviceToken = AppState(),
        pets = AppState(data: []),
        pet = AppState(),
        user = AppState();
}

RootState appReducer(RootState state, action) {
  return RootState(
    auth: authReducer(state.auth, action),
    deviceToken: deviceTokenReducer(state.deviceToken, action),
    pets: petsReducer(state.pets, action),
    pet: petReducer(state.pet, action),
    user: userReducer(state.user, action),
  );
}
