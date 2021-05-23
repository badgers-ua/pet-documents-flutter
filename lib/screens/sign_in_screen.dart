import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/screens/sign_up_screen.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/index.dart';

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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootStore, _SignInScreenScreenViewModel>(
      converter: (store) {
        return _SignInScreenScreenViewModel(
          authState: store.state.auth,
          dispatchLoadSignInThunk:
              (BuildContext ctx, String email, String password) =>
                  store.dispatch(
            loadSignInThunk(
              ctx: ctx,
              email: _emailController.value.text,
              password: _passwordController.value.text,
            ),
          ),
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
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(ThemeConstants.spacing(1)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: ThemeConstants.spacing(1),
                        ),
                        SvgPicture.asset(
                          'assets/images/circle-paw.svg',
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          height: ThemeConstants.spacing(2),
                        ),
                        Text(
                          L10n.of(context).sign_in_screen_welcome_text,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: ThemeConstants.spacing(1),
                        ),
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (input) => input!.isValidEmail()
                              ? null
                              : L10n.of(context)
                                  .sign_in_screen_invalid_email_text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: L10n.of(context)
                                .sign_in_screen_email_text_field_text,
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
                          validator: (input) => input!.isValidPassword()
                              ? null
                              : L10n.of(context)
                                  .sign_in_screen_invalid_password_text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: L10n.of(context)
                                .sign_in_screen_password_text_field_text,
                          ),
                        ),
                        SizedBox(
                          height: ThemeConstants.spacing(1),
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.authState.isLoading
                                ? null
                                : () => _onSubmit(context, vm),
                            child: vm.authState.isLoading
                                ? Opacity(
                                    opacity: vm.authState.isLoading ? 0.3 : 0,
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : Text(
                                    L10n.of(context)
                                        .sign_in_screen_sign_in_button_text,
                                  ),
                          ),
                        ),
                        SizedBox(height: ThemeConstants.spacing(2)),
                        Column(
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
                              child: Text(L10n.of(context).sign_in_screen_sign_up_button_text),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
  final AppState<Auth> authState;

  _SignInScreenScreenViewModel({
    required this.dispatchLoadSignInThunk,
    required this.authState,
  });
}
