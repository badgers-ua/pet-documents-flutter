import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';

class PetCardWidget extends StatelessWidget {
  final GestureTapCallback? onTap;
  final PetPreviewResDto pet;

  PetCardWidget({
    required this.pet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ThemeConstants.spacing(1)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SvgPicture.asset(
                  ThemeConstants.getImageBySpecies(pet.species),
                  color: Theme.of(context).accentColor,
                ),
              ),
              Spacer(),
              Text(pet.name, style: Theme.of(context).textTheme.headline6),
              Text(L10n.of(context).pet_card_widget_subtitle(pet.owners.length.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
