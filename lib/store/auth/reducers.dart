import 'package:pdoc/models/auth.dart';

import 'actions.dart';

AuthState authReducer(AuthState state, action) {
  if (action is LoadAccessToken) {
    return AuthState(
      isLoadingAccessToken: true,
      isLoading: false,
      data: null,
      errorMessage: '',
      errorMessageAccessToken: '',
    );
  }
  if (action is LoadAccessTokenSuccess) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: action.payload,
      errorMessage: '',
      errorMessageAccessToken: '',
    );
  }
  if (action is LoadAccessTokenFailure) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: null,
      errorMessage: '',
      errorMessageAccessToken: action.payload,
    );
  }
  if (action is LoadAccessTokenFailure) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: null,
      errorMessage: action.payload,
      errorMessageAccessToken: '',
    );
  }
  if (action is LoadSignIn) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: true,
      data: null,
      errorMessage: '',
      errorMessageAccessToken: '',
    );
  }
  if (action is LoadSignInSuccess) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: action.payload,
      errorMessage: '',
      errorMessageAccessToken: '',
    );
  }
  if (action is LoadSignInFailure) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: null,
      errorMessage: action.payload,
      errorMessageAccessToken: '',
    );
  }
  if (action is ClearAuthState) {
    return AuthState();
  }
  return state;
}
