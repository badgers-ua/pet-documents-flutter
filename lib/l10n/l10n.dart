import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('uk'),
  ];

  static of(BuildContext context) {
    return AppLocalizations.of(context);
  }
}
