import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';

class PetCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child:  InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          padding: EdgeInsets.all(ThemeConstants.spacing(1)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SvgPicture.asset(
                  'assets/images/paw.svg',
                  color: Theme.of(context).accentColor,
                  // TODO: Responsive
                  width: 72,
                  height: 72,
                ),
              ),
              Spacer(),
              Text("Jill", style: Theme.of(context).textTheme.headline6),
              Text(L10n.of(context).pet_card_widget_subtitle("2")),
            ],
          ),
        ),
      ),
    );
  }
}
