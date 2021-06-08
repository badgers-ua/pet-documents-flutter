import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/screens/add_edit_event_screen.dart';
import 'package:pdoc/screens/add_edit_pet_screen.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_profile_screen.dart';
import 'package:pdoc/screens/sign_in_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/store/auth/actions.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/device-token/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'l10n/l10n.dart';
import 'models/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
          SignInScreen.routeName: (context) => SignInScreen(),
          AddEditEventScreen.routeName: (context) => AddEditEventScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.light,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith(
              (_) => Colors.blue,
            ),
            checkColor: MaterialStateProperty.resolveWith(
              (_) => Colors.white,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith(
              (_) => Colors.blue,
            ),
            checkColor: MaterialStateProperty.resolveWith(
              (_) => Colors.white,
            ),
          ),
        ),
        home: Builder(
          builder: (BuildContext context) => StoreConnector<RootState, _MyAppViewModel>(
            onInit: (store) async {
              if ((await SecureStorageConstants.getRefreshToken()).isEmpty) {
                store.dispatch(LoadAccessTokenFailure(payload: 'No refresh token'));
                return;
              }
              store.dispatch(loadAccessTokenFromRefreshTokenThunk(ctx: context));
            },
            converter: (store) {
              final AuthState authState = store.state.auth;
              final Auth? auth = authState.data;
              final bool isAuthenticated = auth != null && auth.isAuthenticated;
              return _MyAppViewModel(
                error: authState.errorMessageAccessToken.isNotEmpty || authState.errorMessage.isNotEmpty,
                isAuthenticated: isAuthenticated,
                isInitialLoadCompleted: authState.isInitialLoadCompleted,
              );
            },
            ignoreChange: (state) => !state.auth.isInitialLoadCompleted,
            builder: (context, _MyAppViewModel vm) {
              // TODO: Infinite load if API unavailable
              if (!vm.isInitialLoadCompleted) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!vm.isAuthenticated) {
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
  final bool isAuthenticated;
  final bool isInitialLoadCompleted;
  final bool error;

  _MyAppViewModel({
    required this.isAuthenticated,
    required this.isInitialLoadCompleted,
    required this.error,
  });
}

// TODO: Firebase analytics
// TODO: Firebase crashlytics
// TODO: Bigger buttons
