import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';
import 'package:pdoc/extensions/string.dart';

class AddEditPetScreen extends StatelessWidget {
  static const routeName = '/pet-create';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _validateForm() {
    return _formKey.currentState!.validate();
  }

  void showModalSelect({
    required BuildContext ctx,
    required List<ModalSelectOption> options,
    required TextEditingController controller,
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

    if (selectedSpecies == null) {
      return;
    }

    controller.text = selectedSpecies.label;
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    List<ModalSelectOption<SPECIES>> speciesOptions = SPECIES.values.map((v) {
      return ModalSelectOption(
          label: getSpeciesLabel(ctx: context, species: v), value: v);
    }).toList();

    List<ModalSelectOption<GENDER>> genderOptions = GENDER.values.map((v) {
      return ModalSelectOption(
          label: getGenderLabel(ctx: context, gender: v), value: v);
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
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Name'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_name_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _speciesController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Species'),
                      onTap: () => showModalSelect(
                        ctx: context,
                        options: speciesOptions,
                        controller: _speciesController,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_species_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _breedController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Breed'),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_breed_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _genderController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Gender'),
                      onTap: () => showModalSelect(
                        ctx: context,
                        options: genderOptions,
                        controller: _genderController,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_gender_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _dateController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Date'),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_date_of_birth_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _colorController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Color'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_color_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _descriptionController,
                      onChanged: (v) => _validateForm(),
                      validator: (v) =>
                          (v ?? '').requiredValidator(fieldName: 'Description'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .add_edit_pet_screen_description_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _validateForm();
                        },
                        child: Text("Create"),
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
