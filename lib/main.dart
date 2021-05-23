import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/screens/add_edit_pet_screen.dart';
import 'package:pdoc/screens/pet_profile_screen.dart';
import 'package:pdoc/screens/sign_in_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdoc/screens/sign_up_screen.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/store/device_token/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
        // GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainScreen(),
      routes: {
        TabsScreen.routeName: (context) => TabsScreen(),
        AddEditPetScreen.routeName: (context) => AddEditPetScreen(),
        PetProfileScreen.routeName: (context) => PetProfileScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  static final Store<RootStore> store = Store<RootStore>(
    appReducer,
    initialState: RootStore.initialState(),
    middleware: [thunkMiddleware],
  );

  @override
  _MainScreenState createState() => _MainScreenState(store: store);
}

class _MainScreenState extends State<MainScreen> {
  final Store<RootStore> store;

  _MainScreenState({required this.store});

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  void initFCM() async {
    final String? deviceToken = await FirebaseMessaging.instance.getToken();

    store.dispatch(LoadDeviceTokenSuccess(
        payload: DeviceToken(
      deviceToken: deviceToken!,
    )));

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
      store: store,
      child: SignInScreen(),
    );
  }
}
