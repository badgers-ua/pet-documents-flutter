import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

signOutReducer(state, action) {
  if (action is LoadSignOut) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignOutSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignOutFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearSignOutState) {
    return AppState();
  }
  return state;
}
