import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/extensions/string.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/sign-in';

  final _formKey = GlobalKey<FormState>();

  void _onSubmit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(ctx).pushReplacementNamed(TabsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (input) => input!.isValidEmail()
                          ? null
                          : L10n.of(context).sign_in_screen_invalid_email_text,
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
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(context),
                        child: Text(
                          L10n.of(context).sign_in_screen_sign_in_button_text,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
