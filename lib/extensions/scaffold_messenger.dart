import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';

import '../constants.dart';

extension ErrorSnackBar on ScaffoldMessenger {
  void showErrorSnackBar(BuildContext ctx, String errorMsg) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: L10n.of(ctx).scaffold_messenger_extension_dismiss_text,
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text(
          errorMsg,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing(0.5),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}