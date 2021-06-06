import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/index.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/sign-in';

  Future<void> _signInWithGoogle({
    required BuildContext ctx,
    required _SignInScreenScreenViewModel vm,
  }) async {
    vm.dispatchLoadGoogleFirebaseAuth(ctx: ctx);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _SignInScreenScreenViewModel>(
      converter: (store) {
        return _SignInScreenScreenViewModel(
          authState: store.state.auth,
          error: store.state.deviceToken.errorMessage.isNotEmpty,
          deviceToken: store.state.deviceToken.data?.deviceToken ?? '',
          dispatchLoadGoogleFirebaseAuth: ({
            required BuildContext ctx,
          }) =>
              store.dispatch(loadGoogleFirebaseAuth(
            ctx: ctx,
          )),
        );
      },
      distinct: true,
      builder: (context, _SignInScreenScreenViewModel vm) {
        if (vm.error) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(L10n.of(context).something_went_wrong),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(L10n.of(context).sign_in_screen_app_bar_text),
            ),
          ),
          body: Scrollbar(
            child: ListView(
              padding: EdgeInsets.all(ThemeConstants.spacing(1)),
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/circle-paw.svg',
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                Align(
                  child: Text(
                    L10n.of(context).sign_in_screen_welcome_text,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                if (Platform.isIOS)
                  Align(
                    child: SignInButton(
                      Theme.of(context).brightness == Brightness.dark ? Buttons.Apple : Buttons.AppleDark,
                      onPressed: () {},
                      text: L10n.of(context).sign_in_with_apple,
                    ),
                  ),
                Align(
                  child: SignInButton(
                    Theme.of(context).brightness == Brightness.dark ? Buttons.Google : Buttons.GoogleDark,
                    onPressed: () => _signInWithGoogle(ctx: context, vm: vm),
                    text: L10n.of(context).sign_in_with_google,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SignInScreenScreenViewModel {
  final dispatchLoadGoogleFirebaseAuth;
  final String deviceToken;
  final bool error;
  final AuthState authState;

  _SignInScreenScreenViewModel({
    required this.dispatchLoadGoogleFirebaseAuth,
    required this.authState,
    required this.error,
    required this.deviceToken,
  });
}
