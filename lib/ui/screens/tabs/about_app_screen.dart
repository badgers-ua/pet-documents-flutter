import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/ui/widgets/privacy_and_terms_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

// TODO: send you feedback to developer
class AboutAppScreen extends StatelessWidget {
  static const routeName = '/about-app';

  const AboutAppScreen({Key? key}) : super(key: key);

  void _launchMailToDeveloper() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AboutAppConstants.supportEmail,
      query: encodeQueryParameters(<String, String>{'subject': 'Feedback'}),
    );

    launch(emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).about_app)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/app-icon.svg',
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: 150,
            width: 150,
          ),
          SizedBox(height: ThemeConstants.spacing(1)),
          Text(
            L10n.of(context).your_pets_in_your_pocket,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: ThemeConstants.spacing(2)),
          Column(
            children: [
              Text(L10n.of(context).share_feedback),
              TextButton(
                child: Text(AboutAppConstants.supportEmail),
                onPressed: () {
                  _launchMailToDeveloper();
                },
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.spacing(3)),
          PrivacyAndTermsWidget(),
          SizedBox(height: ThemeConstants.spacing(2)),
        ],
      ),
    );
  }
}
