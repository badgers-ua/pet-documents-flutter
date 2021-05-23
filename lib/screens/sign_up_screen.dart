import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).sign_up_screen_app_bar_text),
      ),
    );
  }
}
