import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/screens/add_edit_pet_screen.dart';
import 'package:pdoc/screens/pet_profile_screen.dart';
import 'package:pdoc/screens/sign_in_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdoc/screens/sign_up_screen.dart';
import 'package:pdoc/screens/tabs/tabs_screen.dart';
import 'package:pdoc/store/auth/actions.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/device_token/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'l10n/l10n.dart';
import 'models/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final Store<RootState> store = Store<RootState>(
    appReducer,
    initialState: RootState.initialState(),
    middleware: [thunkMiddleware],
  );

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initFCM();
  }

  void initFCM() async {
    final String? deviceToken = await FirebaseMessaging.instance.getToken();

    MyApp.store.dispatch(
      LoadDeviceTokenSuccess(
        payload: DeviceToken(
          deviceToken: deviceToken!,
        ),
      ),
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<RootState>(
      store: MyApp.store,
      child: MaterialApp(
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
          // GlobalCupertinoLocalizations.delegate
        ],
        routes: {
          TabsScreen.routeName: (context) => TabsScreen(),
          AddEditPetScreen.routeName: (context) => AddEditPetScreen(),
          PetProfileScreen.routeName: (context) => PetProfileScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          SignInScreen.routeName: (context) => SignInScreen(),
        },
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Builder(
          builder: (BuildContext context) =>
              StoreConnector<RootState, _MyAppViewModel>(
            onInit: (store) async {
              if ((await FlutterSecureStorage().read(key: 'refresh_token') ??
                      '')
                  .isEmpty) {
                store.dispatch(
                    LoadAccessTokenFailure(payload: 'No refresh token'));
                return;
              }
              store.dispatch(loadAccessTokenFromRefreshTokenThunk());
            },
            converter: (store) {
              return _MyAppViewModel(auth: store.state.auth);
            },
            ignoreChange: (RootState state) {
              final AuthState auth = state.auth;

              final bool isNotEmptyErrorMessage = auth.errorMessage.isNotEmpty;
              final bool isNotEmptyErrorMessageAccessToken =
                  auth.errorMessageAccessToken.isEmpty;

              final bool ignoreChangeOnErrorChange =
                  isNotEmptyErrorMessage || isNotEmptyErrorMessageAccessToken;

              return ignoreChangeOnErrorChange ||
                  (auth.data != null &&
                      auth.data.refreshToken.isNotEmpty &&
                      (auth.isLoadingAccessToken ||
                          !auth.isLoadingAccessToken));
            },
            builder: (context, _MyAppViewModel vm) {
              // TODO: Verify infinite loader bug
              if (vm.auth.isLoadingAccessToken) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final Auth? auth = vm.auth.data;
              if (auth == null ||
                  (!auth.isAuthenticated && !vm.auth.isLoading)) {
                return SignInScreen();
              }
              return TabsScreen();
            },
          ),
        ),
      ),
    );
  }
}

class _MyAppViewModel {
  final AuthState auth;

  _MyAppViewModel({required this.auth});
}
