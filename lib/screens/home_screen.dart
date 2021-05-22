import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/widgets/event_card_widget.dart';
import 'package:pdoc/widgets/pet_card_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(ThemeConstants.spacing(1)),
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ThemeConstants.spacing(0.5),
            left: ThemeConstants.spacing(0.5),
          ),
          child: Text(
            L10n.of(context).home_screen_pets_title_text,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: ThemeConstants.spacing(0.5),
          mainAxisSpacing: ThemeConstants.spacing(0.5),
          crossAxisCount: 2,
          children: <Widget>[
            PetCardWidget(),
            PetCardWidget(),
            PetCardWidget(),
            PetCardWidget(),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(ThemeConstants.spacing(0.5)),
          child: Text(
            L10n.of(context).home_screen_events_title_text,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        EventCardWidget(),
        EventCardWidget(),
        EventCardWidget(),
      ],
    );
  }
}
