import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';

import '../constants.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool enabled;
  final Function onSubmit;

  ConfirmationDialogWidget({
    required this.title,
    required this.content,
    required this.enabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        height: 125,
        child: Column(
          children: [
            Spacer(),
            Text(content),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: !enabled
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    L10n.of(context).cancel_text,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: !enabled
                      ? null
                      : () {
                          onSubmit();
                        },
                  child: !enabled
                      ? ThemeConstants.getButtonSpinner()
                      : Text(
                          L10n.of(context).done_text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
