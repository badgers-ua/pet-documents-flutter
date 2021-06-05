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
import 'package:pdoc/models/dto/request/social_sign_in_req_dto.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/sign-in';

  Future<void> _signInWithGoogle({
    required BuildContext ctx,
    required _SignInScreenScreenViewModel vm,
  }) async {
    final PLATFORM? platform = getPlatformByPlatformName(osName: Platform.operatingSystem);

    if (platform == null) {
      print('Unknown platform');
      return;
    }

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    final GoogleSignInAccount? account = googleUser;

    if (account == null) {
      return;
    }

    final SocialSignInReqDto request = SocialSignInReqDto(
      token: (await account.authentication).idToken!,
      socialType: SOCIAL_TYPE.GOOGLE,
      email: account.email,
      firstName: account.displayName!.split(" ")[0],
      lastName: account.displayName!.split(" ")[1],
      deviceToken: vm.deviceToken,
      platform: platform,
      avatar: account.photoUrl!,
    );

    vm.dispatchLoadSocialSignInThunk(ctx: ctx, request: request);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _SignInScreenScreenViewModel>(
      converter: (store) {
        return _SignInScreenScreenViewModel(
          authState: store.state.auth,
          deviceToken: store.state.deviceToken.data!.deviceToken,
          dispatchLoadSocialSignInThunk: ({
            required BuildContext ctx,
            required SocialSignInReqDto request,
          }) =>
              store.dispatch(loadSocialSignInThunk(
            ctx: ctx,
            request: request,
          )),
        );
      },
      distinct: true,
      builder: (context, _SignInScreenScreenViewModel vm) {
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
  final dispatchLoadSocialSignInThunk;
  final String deviceToken;
  final AuthState authState;

  _SignInScreenScreenViewModel({
    required this.dispatchLoadSocialSignInThunk,
    required this.authState,
    required this.deviceToken,
  });
}
