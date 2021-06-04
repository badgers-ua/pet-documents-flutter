import 'package:flutter/material.dart';

import 'l10n/l10n.dart';

class ThemeConstants {
  static final _padding = 16.0;

  static double spacing(double val) {
    return _padding * val;
  }

  static Widget getButtonSpinner() {
    return Opacity(
      opacity: 0.3,
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  static void showSnackBar({
    required BuildContext ctx,
    required String msg,
    Duration duration = const Duration(seconds: 3),
    Color color = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: color,
        action: SnackBarAction(
          label: L10n.of(ctx).scaffold_messenger_extension_dismiss_text,
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing(0.5),
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}

class Api {
  // Android
  // static const baseUrl = 'http://10.0.2.2:5000/api/v2';
  // static const baseUrl = 'http://localhost:5000/api/v2';
  static const baseUrl = 'https://p-doc.com/api/v2';
}
