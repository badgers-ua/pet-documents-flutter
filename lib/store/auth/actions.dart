import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdoc/models/auth.dart';
import 'package:redux/redux.dart';

import '../index.dart';

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

void loadAccessTokenFromRefreshToken(Store<RootStore> store) async {
  store.dispatch(LoadSignIn());
  try {
    // final Auth auth = await AuthService.fetchTokenSilently();
    // store.dispatch(LoadSignInSilentlySuccess(payload: auth));
    // store.dispatch(SetUserState(payload: User.getUserFromToken(auth.idToken!)));
  } catch (e) {
    // store.dispatch(LoadSignInSilentlyFailure(payload: e.toString()));
  }
}

void signOutThunk(Store<RootStore> store) async {
  // AuthService.clearRefreshToken();
  // store.dispatch(ClearAuthState());
  // store.dispatch(ClearUserState());
  // store.dispatch(ClearPetsState());
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

class LoadSignInSilently extends AppAction {}

class LoadSignInSilentlySuccess extends AppAction {
  final Auth payload;

  LoadSignInSilentlySuccess({required this.payload});
}

class LoadSignInSilentlyFailure extends AppAction {
  final String payload;

  LoadSignInSilentlyFailure({required this.payload});
}

class ClearAuthState extends AppAction {}
