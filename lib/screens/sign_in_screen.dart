import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/social_sign_in_req_dto.dart';
import 'package:pdoc/screens/sign_up_screen.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/sign-in';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onSubmit(BuildContext ctx, _SignInScreenScreenViewModel vm) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String email = _emailController.value.text;
    final String password = _passwordController.value.text;
    vm.dispatchLoadSignInThunk(ctx, email, password);
  }

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
          dispatchLoadSignInThunk: (BuildContext ctx, String email, String password) => store.dispatch(
            loadSignInThunk(
              ctx: ctx,
              email: _emailController.value.text,
              password: _passwordController.value.text,
            ),
          ),
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
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (input) =>
                        input!.isValidEmail() ? null : L10n.of(context).invalid_email_text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).email,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (input) =>
                        input!.isValidPassword() ? null : L10n.of(context).invalid_password_text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).password,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  Align(
                    child: SignInButtonBuilder(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      textColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                      onPressed: vm.authState.isLoading ? () {} : () => _onSubmit(context, vm),
                      icon: Icons.email_outlined,
                      iconColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                      text: L10n.of(context).sign_in_screen_sign_in_button_text,
                    ),
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
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(L10n.of(context).sign_in_screen_no_account_text),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(SignUpScreen.routeName);
                          },
                          child: Text(L10n.of(context).sign_up),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignInScreenScreenViewModel {
  final dispatchLoadSignInThunk;
  final dispatchLoadSocialSignInThunk;
  final String deviceToken;
  final AuthState authState;

  _SignInScreenScreenViewModel({
    required this.dispatchLoadSignInThunk,
    required this.dispatchLoadSocialSignInThunk,
    required this.authState,
    required this.deviceToken,
  });
}
