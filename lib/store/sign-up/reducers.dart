import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

AppState signUpReducer(
    AppState state, action) {
  if (action is LoadSignUp) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignUpSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadSignUpFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearSignUpState) {
    return AppState();
  }
  return state;
}
