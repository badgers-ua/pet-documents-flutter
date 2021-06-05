import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
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
              if ((await FlutterSecureStorage().read(key: 'refresh_token') ?? '').isEmpty) {
                store.dispatch(LoadAccessTokenFailure(payload: 'No refresh token'));
                return;
              }
              store.dispatch(loadAccessTokenFromRefreshTokenThunk(ctx: context));
            },
            converter: (store) {
              final Auth? auth = store.state.auth.data;
              final UserResDto? user = store.state.user.data;
              final bool isAuthenticated = auth != null && auth.isAuthenticated;
              return _MyAppViewModel(
                isAuthenticated: isAuthenticated,
                isInitialLoadCompleted: store.state.auth.isInitialLoadCompleted,
                isUserLoaded: user != null,
              );
            },
            builder: (context, _MyAppViewModel vm) {
              // TODO: Infinite loader if on app launch API not available
              if (!vm.isInitialLoadCompleted && !vm.isUserLoaded) {
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
  final bool isUserLoaded;

  _MyAppViewModel({
    required this.isAuthenticated,
    required this.isInitialLoadCompleted,
    required this.isUserLoaded,
  });
}
