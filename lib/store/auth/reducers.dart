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
      isInitialLoadCompleted: state.isInitialLoadCompleted,
    );
  }
  if (action is LoadAccessTokenSuccess) {
    print(action.payload.accessToken);
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: action.payload,
      errorMessage: '',
      errorMessageAccessToken: '',
      isInitialLoadCompleted: true,
    );
  }
  if (action is LoadAccessTokenFailure) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: null,
      errorMessage: '',
      errorMessageAccessToken: action.payload,
      isInitialLoadCompleted: true,
    );
  }
  if (action is LoadSignIn) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: true,
      data: null,
      errorMessage: '',
      errorMessageAccessToken: '',
      isInitialLoadCompleted: state.isInitialLoadCompleted,
    );
  }
  if (action is LoadSignInSuccess) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: action.payload,
      errorMessage: '',
      errorMessageAccessToken: '',
      isInitialLoadCompleted: state.isInitialLoadCompleted,
    );
  }
  if (action is LoadSignInFailure) {
    return AuthState(
      isLoadingAccessToken: false,
      isLoading: false,
      data: null,
      errorMessage: action.payload,
      errorMessageAccessToken: '',
      isInitialLoadCompleted: state.isInitialLoadCompleted,
    );
  }
  if (action is ClearAuthState) {
    return AuthState();
  }
  return state;
}
