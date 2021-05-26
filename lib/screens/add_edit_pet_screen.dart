import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';

class AddEditPetScreen extends StatelessWidget {
  static const routeName = '/pet-create';

  void showModalSelect({
    required BuildContext ctx,
    required List<ModalSelectOption> options,
  }) async {
    final widget = ModalSelectWidget(
      title: L10n.of(ctx).modal_select_app_bar_select_species_text,
      options: options,
    );

    if (Platform.isIOS) {
      final ModalSelectOption? selectedSpecies =
          await showCupertinoModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );
      return;
    }

    final ModalSelectOption? selectedSpecies =
        await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ModalSelectOption> speciesOptions = SPECIES.values.map((s) {
      return ModalSelectOption(
          label: getSpeciesLabel(ctx: context, species: s), value: s);
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: Text(L10n.of(context).add_edit_pet_screen_app_bar_text)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(ThemeConstants.spacing(1)),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_name_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      onTap: () => showModalSelect(
                        ctx: context,
                        options: speciesOptions,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_species_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_breed_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_gender_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_date_of_birth_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_color_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_description_input_text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
