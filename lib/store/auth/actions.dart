import 'package:pdoc/models/auth.dart';
import 'package:redux/redux.dart';

import '../index.dart';

void signOutThunk(Store<RootState> store) async {
  // AuthService.clearRefreshToken();
  // store.dispatch(ClearAuthState());
  // store.dispatch(ClearUserState());
  // store.dispatch(ClearPetsState());
}

class LoadAccessToken extends AppAction {}

class LoadAccessTokenSuccess extends AppAction {
  final Auth payload;

  LoadAccessTokenSuccess({required this.payload});
}

class LoadAccessTokenFailure extends AppAction {
  final String payload;

  LoadAccessTokenFailure({required this.payload});
}

class LoadSignIn extends AppAction {}

class LoadSignInSuccess extends AppAction {
  final Auth payload;

  LoadSignInSuccess({required this.payload});
}

class LoadSignInFailure extends AppAction {
  final String payload;

  LoadSignInFailure({required this.payload});
}

class ClearAuthState extends AppAction {}
