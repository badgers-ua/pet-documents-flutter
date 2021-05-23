import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/pets/reducers.dart';

import 'auth/reducers.dart';
import 'device_token/reducers.dart';

abstract class AppAction {
  String toString() {
    return '$runtimeType';
  }
}

class RootStore {
  final AuthState auth;
  final AppState<DeviceToken> deviceToken;
  final AppState<List<PetPreviewResDto>> pets;

  RootStore(
      {required this.auth, required this.deviceToken, required this.pets});

  RootStore.initialState()
      : auth = AuthState(isLoadingAccessToken: true),
        deviceToken = AppState(),
        pets = AppState(data: []);
}

RootStore appReducer(RootStore state, action) {
  return RootStore(
    auth: authReducer(state.auth, action),
    deviceToken: deviceTokenReducer(state.deviceToken, action),
    pets: petsReducer(state.pets, action),
  );
}
