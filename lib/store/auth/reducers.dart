import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';

import 'actions.dart';

AppState<Auth> authReducer(AppState<Auth> state, action) {
  if (action is LoadSignInSilently) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignInSilentlySuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadSignInSilentlyFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is LoadSignIn) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignInSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadSignInFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearAuthState) {
    return AppState();
  }
  return state;
}
