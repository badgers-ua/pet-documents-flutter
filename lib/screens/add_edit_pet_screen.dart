import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';
import 'package:pdoc/store/breeds/effects.dart';
import 'package:pdoc/store/index.dart';
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
    required _AddEditPetScreenViewModel vm,
    bool isSpecies = false,
  }) async {
    final widget = ModalSelectWidget(
      title: L10n.of(ctx).modal_select_app_bar_select_species_text,
      options: options,
    );

    if (Platform.isIOS) {
      final ModalSelectOption? modalSelectOption =
          await showCupertinoModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );

      _setModalSelectFrmValue(
        ctx: ctx,
        modalSelectOption: modalSelectOption,
        controller: controller,
        vm: vm,
        isSpecies: isSpecies,
      );

      return;
    }

    final ModalSelectOption? modalSelectOption =
        await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );

    _setModalSelectFrmValue(
      ctx: ctx,
      modalSelectOption: modalSelectOption,
      controller: controller,
      vm: vm,
      isSpecies: isSpecies,
    );
  }

  void _setModalSelectFrmValue({
    required BuildContext ctx,
    required ModalSelectOption? modalSelectOption,
    required TextEditingController controller,
    required _AddEditPetScreenViewModel vm,
    required bool isSpecies,
  }) {
    if (modalSelectOption == null) {
      return;
    }

    if (isSpecies) {
      _breedController.text = '';
      vm.dispatchLoadBreedsBySpeciesThunk(
          ctx: ctx, species: modalSelectOption.value);
    }

    controller.text = modalSelectOption.label;
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

    return StoreConnector<RootState, _AddEditPetScreenViewModel>(
      converter: (store) {
        final List<StaticResDto> breeds = (_speciesController.text.isNotEmpty
            ? store.state.breeds.data![speciesOptions
                .firstWhere(
                    (element) => element.label == _speciesController.text)
                .value] ?? []
            : []);

        return _AddEditPetScreenViewModel(
          isLoadingBreeds: store.state.breeds.isLoading,
          // TODO: Empty when initially breeds are loaded in store
          breedOptions: breeds
              .map((e) => ModalSelectOption(label: e.name, value: e.id))
              .toList(),
          dispatchLoadBreedsBySpeciesThunk: ({
            required BuildContext ctx,
            required SPECIES species,
          }) =>
              store.dispatch(
            loadBreedsBySpeciesThunk(ctx: ctx, species: species),
          ),
        );
      },
      builder: (context, _AddEditPetScreenViewModel vm) {
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
                          validator: (v) =>
                              (v ?? '').requiredValidator(fieldName: 'Species'),
                          onTap: () => showModalSelect(
                            ctx: context,
                            options: speciesOptions,
                            controller: _speciesController,
                            vm: vm,
                            isSpecies: true,
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
                          onTap: () => vm.isLoadingBreeds ? null : showModalSelect(
                            ctx: context,
                            options: vm.breedOptions,
                            controller: _breedController,
                            vm: vm,
                          ),
                          readOnly: true,
                          enabled: !vm.isLoadingBreeds,
                          decoration: InputDecoration(
                            suffixIconConstraints: BoxConstraints(maxWidth: 48, maxHeight: 25, minWidth: 48, minHeight: 25),
                            suffixIcon: !vm.isLoadingBreeds ? null : SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 23),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: L10n.of(context)
                                .add_edit_pet_screen_breed_input_text,
                          ),
                        ),
                        SizedBox(height: ThemeConstants.spacing(1)),
                        TextFormField(
                          controller: _genderController,
                          onTap: () => showModalSelect(
                            ctx: context,
                            options: genderOptions,
                            vm: vm,
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: L10n.of(context)
                                .add_edit_pet_screen_color_input_text,
                          ),
                        ),
                        SizedBox(height: ThemeConstants.spacing(1)),
                        TextFormField(
                          controller: _descriptionController,
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
      },
    );
  }
}

class _AddEditPetScreenViewModel {
  final dispatchLoadBreedsBySpeciesThunk;
  final bool isLoadingBreeds;
  final List<ModalSelectOption<String>> breedOptions;

  _AddEditPetScreenViewModel({
    required this.dispatchLoadBreedsBySpeciesThunk,
    required this.isLoadingBreeds,
    required this.breedOptions,
  });
}
