import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/store/device-token/actions.dart';

AppState<DeviceToken> deviceTokenReducer(AppState<DeviceToken> state, action) {
  if (action is LoadDeviceTokenSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  return state;
}
