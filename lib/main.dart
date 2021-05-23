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
import 'package:pdoc/screens/tabs_screen.dart';
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
  static final Store<RootStore> store = Store<RootStore>(
    appReducer,
    initialState: RootStore.initialState(),
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
    return StoreProvider<RootStore>(
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
              StoreConnector<RootStore, RootStore>(
            onInit: (store) async {
              if ((await FlutterSecureStorage().read(key: 'refresh_token') ??
                      '')
                  .isEmpty) {
                return;
              }
              store
                  .dispatch(loadAccessTokenFromRefreshTokenThunk(ctx: context));
            },
            converter: (store) => store.state,
            ignoreChange: (RootStore state) => true,
            builder: (context, RootStore state) {
              if (state.auth.isLoadingAccessToken) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final Auth? auth = state.auth.data;
              if (auth == null ||
                  (!auth.isAuthenticated && !state.auth.isLoading)) {
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
