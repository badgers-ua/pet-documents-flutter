import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class PrivacyAndTermsWidget extends StatelessWidget {
  const PrivacyAndTermsWidget({Key? key}) : super(key: key);

  Future<void> _launchInWebViewWithJavaScript({
    required BuildContext ctx,
    required String url,
  }) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      ThemeConstants.showSnackBar(
          ctx: ctx, msg: L10n.of(ctx).error_launching_url(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(
            L10n
                .of(context)
                .privacy_policy,
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
          onPressed: () =>
          {
            _launchInWebViewWithJavaScript(
              url: AboutAppConstants.privacyUrl,
              ctx: context,
            )
          },
        ),
        SizedBox(width: ThemeConstants.spacing(0.5)),
        Text('|'),
        SizedBox(width: ThemeConstants.spacing(0.5)),
        TextButton(
          child: Text(
            L10n
                .of(context)
                .terms_of_service,
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
          onPressed: () =>
          {
            _launchInWebViewWithJavaScript(
              url: AboutAppConstants.termsUrl,
              ctx: context,
            )
          },
        ),
      ],
    );
  }
}
