import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/request/sign_up_req_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/store/sign-up/effects.dart';

import '../constants.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up';

  // TODO: Max length on all inputs within app
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  void _onSubmit({
    required BuildContext ctx,
    required _SignUpScreenViewModel vm,
  }) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String email = _emailController.value.text;
    final String password = _passwordController.value.text;
    final String firstName = _firstNameController.value.text;
    final String lastName = _lastNameController.value.text;

    final SignUpReqDto signUpReqDto = SignUpReqDto(
      deviceToken: vm.deviceToken,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    vm.dispatchLoadSignUpThunk(request: signUpReqDto);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _SignUpScreenViewModel>(
      converter: (store) {
        return _SignUpScreenViewModel(
          deviceToken: store.state.deviceToken.data!.deviceToken,
          isLoading: store.state.signUp.isLoading,
          dispatchLoadSignUpThunk: ({required SignUpReqDto request}) {
            store.dispatch(loadSignUpThunk(ctx: context, request: request));
          },
        );
      },
      distinct: true,
      builder: (context, _SignUpScreenViewModel vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text(L10n.of(context).sign_up_screen_app_bar_text),
          ),
          body: Scrollbar(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(ThemeConstants.spacing(1)),
                children: <Widget>[
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (input) => input!.isValidEmail() ? null : L10n.of(context).invalid_email_text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).email,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (input) =>
                        input!.requiredValidator(fieldName: L10n.of(context).first_name, ctx: context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).first_name,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (input) => input!.requiredValidator(fieldName: L10n.of(context).last_name, ctx: context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).last_name,
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
                    validator: (input) {
                      if (!input!.isValidPassword()) {
                        return L10n.of(context).invalid_password_text;
                      }
                      if (!input.isPasswordMatchesWith(_repeatPasswordController.text)) {
                        return L10n.of(context).passwords_not_matched_text;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).password,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (input) {
                      if (!input!.isValidPassword()) {
                        return L10n.of(context).invalid_password_text;
                      }
                      if (!input.isPasswordMatchesWith(_passwordController.text)) {
                        return L10n.of(context).passwords_not_matched_text;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: L10n.of(context).repeat_password,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.spacing(1),
                  ),
                  ElevatedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () {
                            _onSubmit(ctx: context, vm: vm);
                          },
                    child: vm.isLoading ? ThemeConstants.getButtonSpinner() : Text(L10n.of(context).sign_up),
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

class _SignUpScreenViewModel {
  final bool isLoading;
  final String deviceToken;
  final dispatchLoadSignUpThunk;

  _SignUpScreenViewModel({
    required this.isLoading,
    required this.deviceToken,
    required this.dispatchLoadSignUpThunk,
  });
}
