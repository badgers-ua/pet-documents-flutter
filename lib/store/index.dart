import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/device_token.dart';

import 'auth/reducers.dart';
import 'device_token/reducers.dart';

abstract class AppAction {
  String toString() {
    return '$runtimeType';
  }
}

class RootStore {
  final AppState<Auth> auth;
  final AppState<DeviceToken> deviceToken;


  RootStore({
    required this.auth,
    required this.deviceToken,
  });

  RootStore.initialState()
      : auth = AppState(),
       deviceToken = AppState();
}

RootStore appReducer(RootStore state, action) {
  return RootStore(
    auth: authReducer(state.auth, action),
    deviceToken: deviceTokenReducer(state.deviceToken, action),
  );
}
