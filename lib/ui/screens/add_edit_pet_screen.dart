import 'dart:async';
import 'dart:io' show File, Platform;
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/date_picker_value.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';
import 'package:pdoc/store/add-pet/effects.dart';
import 'package:pdoc/store/breeds/effects.dart';
import 'package:pdoc/store/edit-pet/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/ui/widgets/date_picker_widget.dart';
import 'package:pdoc/ui/widgets/image_capture.dart';
import 'package:pdoc/ui/widgets/modal_select_widget.dart';

class AddEditPetScreen extends StatefulWidget {
  static const routeName = '/pet-create-edit';

  @override
  _AddEditPetScreenState createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _speciesController = TextEditingController();

  final TextEditingController _breedController = TextEditingController();

  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  DatePickerValue? _selectedDate;

  File? _selectedAvatar;

  bool isExpanded = false;

  final ScrollController _scrollController = ScrollController();

  bool _validateForm() {
    return _formKey.currentState != null && _formKey.currentState!.validate();
  }

  void showModalSelect({
    required BuildContext ctx,
    required List<ModalSelectOption> options,
    required TextEditingController controller,
    required _AddEditPetScreenViewModel vm,
    required String modalTitle,
    String? modalHintText,
    bool isSpecies = false,
    bool isBreeds = false,
  }) async {
    final widget = ModalSelectWidget(
      title: modalTitle,
      options: options,
      helperText: !isBreeds ? null : L10n.of(ctx).modal_select_search_bar_breeds_hint_text,
    );

    if (Platform.isIOS) {
      final ModalSelectOption? modalSelectOption = await showCupertinoModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );

      _setModalSelectFormValue(
        ctx: ctx,
        modalSelectOption: modalSelectOption,
        controller: controller,
        vm: vm,
        isSpecies: isSpecies,
      );

      return;
    }

    final ModalSelectOption? modalSelectOption = await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );

    _setModalSelectFormValue(
      ctx: ctx,
      modalSelectOption: modalSelectOption,
      controller: controller,
      vm: vm,
      isSpecies: isSpecies,
    );
  }

  void _setModalSelectFormValue({
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
      vm.dispatchLoadBreedsBySpeciesThunk(ctx: ctx, species: modalSelectOption.value);
    }

    controller.text = modalSelectOption.label;
    _validateForm();
  }

  Future<void> _presetForm({
    required BuildContext ctx,
    required PetResDto pet,
    required List<ModalSelectOption<SPECIES>> speciesOptions,
    required List<ModalSelectOption<GENDER>> genderOptions,
    required List<ModalSelectOption<String>> breedOptions,
    required _AddEditPetScreenViewModel vm,
  }) async {
    if (_validateForm()) {
      return;
    }
    _nameController.text = pet.name;
    _speciesController.text = speciesOptions.firstWhere((element) => element.value == pet.species).label;
    if (pet.gender != null) {
      _genderController.text = genderOptions.firstWhere((element) => element.value == pet.gender).label;
    }
    if (pet.breed != null) {
      _breedController.text = pet.breed!.name;
    }
    if (pet.weight != null) {
      _weightController.text = pet.weight!.toString();
    }
    if (pet.dateOfBirth != null) {
      final DateTime dateTimeBirth = DateTime.parse(pet.dateOfBirth!).toLocal();
      final String formattedDate =
          intl.DateFormat.yMMMd(Localizations.localeOf(ctx).languageCode).format(dateTimeBirth).toString();
      _dateController.text = formattedDate;
      _selectedDate = DatePickerValue(dateTime: dateTimeBirth, formattedDate: formattedDate);
    }
    if (pet.colour != null) {
      _colorController.text = pet.colour!;
    }
    if (pet.notes != null) {
      _descriptionController.text = pet.notes!;
    }
    if (vm.petAvatarUrl.isNotEmpty) {
      File formattedPickedFile = await vm.petAvatarUrl.getFileFromCachedImage();

      _selectedAvatar = formattedPickedFile;
    }
  }

  SPECIES _getSpeciesByOptionLabel({required List<ModalSelectOption<SPECIES>> speciesOptions}) {
    return speciesOptions.firstWhere((element) => element.label == _speciesController.text).value;
  }

  _onSubmit({
    required _AddEditPetScreenViewModel vm,
    required List<ModalSelectOption<GENDER>> genderOptions,
    required List<ModalSelectOption<SPECIES>> speciesOptions,
  }) {
    if (!_validateForm()) {
      _scrollController.jumpTo(0);
      return;
    }

    CreatePetReqDto createPetReqDto = CreatePetReqDto(
      name: _nameController.text.trim(),
      species: _getSpeciesByOptionLabel(speciesOptions: speciesOptions),
    );

    if (_breedController.text.isNotEmpty) {
      createPetReqDto.breed = vm.breedOptions.firstWhere((element) => element.label == _breedController.text).value;
    }
    if (_genderController.text.isNotEmpty) {
      createPetReqDto.gender = genderOptions.firstWhere((element) => element.label == _genderController.text).value;
    }
    if (_selectedDate != null) {
      createPetReqDto.dateOfBirth = _selectedDate!.dateTime.toUtc().toIso8601String();
    }
    if (_weightController.text.isNotEmpty) {
      createPetReqDto.weight = double.parse(_weightController.text);
    }
    if (_colorController.text.isNotEmpty) {
      createPetReqDto.colour = _colorController.text;
    }
    if (_descriptionController.text.isNotEmpty) {
      createPetReqDto.notes = _descriptionController.text;
    }
    if (_selectedAvatar != null) {
      createPetReqDto.avatar = this._selectedAvatar;
    }

    if (!vm.isEditMode) {
      vm.dispatchLoadCreatePetThunk(
        ctx: context,
        request: createPetReqDto,
      );
      return;
    }

    vm.dispatchLoadEditPetThunk(
      ctx: context,
      request: createPetReqDto,
      petId: vm.pet!.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ModalSelectOption<SPECIES>> speciesOptions = SPECIES.values.map((v) {
      return ModalSelectOption(label: getSpeciesLabel(ctx: context, species: v), value: v);
    }).toList();

    List<ModalSelectOption<GENDER>> genderOptions = GENDER.values.map((v) {
      return ModalSelectOption(label: getGenderLabel(ctx: context, gender: v), value: v);
    }).toList();

    return StoreConnector<RootState, _AddEditPetScreenViewModel>(
      onInit: (store) {
        final PetResDto? currentPet = store.state.pet.data!.petResDto;
        final bool editMode = currentPet != null;

        if (!editMode) {
          return;
        }

        store.dispatch(loadBreedsBySpeciesThunk(ctx: context, species: currentPet.species));
      },
      converter: (store) {
        final PetResDto? currentPet = store.state.pet.data!.petResDto;

        final bool isEditMode = currentPet != null;

        final SPECIES? selectedSpecies = store.state.breeds.selectedSpecies;
        final List<StaticResDto> breeds =
            (selectedSpecies != null ? store.state.breeds.data[selectedSpecies] ?? [] : []);

        final List<ModalSelectOption<String>> breedOptions =
            breeds.map((e) => ModalSelectOption(label: e.name, value: e.id)).toList();

        final vm = _AddEditPetScreenViewModel(
          isLoadingBreeds: store.state.breeds.isLoading,
          breedOptions: breedOptions,
          isEditMode: isEditMode,
          pet: currentPet,
          petAvatarUrl: store.state.pet.data!.avatarUrl,
          error: store.state.pet.errorMessage.isNotEmpty,
          isLoadingCreatePet: store.state.addPet.isLoading,
          isLoadingEditPet: store.state.editPet.isLoading,
          dispatchLoadBreedsBySpeciesThunk: ({
            required BuildContext ctx,
            required SPECIES species,
          }) =>
              store.dispatch(
            loadBreedsBySpeciesThunk(ctx: ctx, species: species),
          ),
          dispatchLoadCreatePetThunk: ({
            required BuildContext ctx,
            required CreatePetReqDto request,
          }) =>
              store.dispatch(
            loadCreatePetThunk(
              ctx: ctx,
              request: request,
            ),
          ),
          dispatchLoadEditPetThunk: ({
            required BuildContext ctx,
            required CreatePetReqDto request,
            required String petId,
          }) =>
              store.dispatch(
            loadEditPetThunk(
              ctx: ctx,
              request: request,
              petId: petId,
            ),
          ),
        );

        return vm;
      },
      builder: (context, _AddEditPetScreenViewModel vm) {
        if (vm.error) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(L10n.of(context).something_went_wrong),
            ),
          );
        }

        if (vm.isEditMode) {
          _presetForm(
            pet: vm.pet!,
            ctx: context,
            genderOptions: genderOptions,
            breedOptions: vm.breedOptions,
            vm: vm,
            speciesOptions: speciesOptions,
          );
        }

        final List<Widget> _formWidgets = [
          ImageCapture(
            initialImage: vm.petAvatarUrl.isEmpty ? null : vm.petAvatarUrl,
            noImageSvgAsset: ThemeConstants.getImageBySpecies(
                _speciesController.text.isNotEmpty ? _getSpeciesByOptionLabel(speciesOptions: speciesOptions) : null),
            onChange: (File? file) {
              _selectedAvatar = file;
            },
          ),
          SizedBox(height: ThemeConstants.spacing(1)),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _nameController,
            onChanged: (v) => _validateForm(),
            maxLength: 20,
            validator: (v) => (v ?? '').requiredValidator(
              fieldName: L10n.of(context).add_edit_pet_screen_name_input_text,
              ctx: context,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: L10n.of(context).add_edit_pet_screen_name_input_text,
            ),
          ),
          SizedBox(height: ThemeConstants.spacing(1)),
          TextFormField(
            controller: _speciesController,
            validator: (v) => (v ?? '')
                .requiredValidator(fieldName: L10n.of(context).add_edit_pet_screen_species_input_text, ctx: context),
            onTap: () => showModalSelect(
              modalTitle: L10n.of(context).modal_select_app_bar_select_species_text,
              ctx: context,
              options: speciesOptions,
              controller: _speciesController,
              vm: vm,
              isSpecies: true,
            ),
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.keyboard_arrow_right),
              border: OutlineInputBorder(),
              labelText: L10n.of(context).add_edit_pet_screen_species_input_text,
            ),
          ),
          SizedBox(height: ThemeConstants.spacing(1)),
          ExpansionPanelList(
            elevation: 0,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                this.isExpanded = !this.isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(L10n.of(context).optional_fields),
                  );
                },
                body: Column(
                  children: [
                    SizedBox(height: 2),
                    TextFormField(
                      controller: _breedController,
                      onTap: () => vm.isLoadingBreeds
                          ? null
                          : showModalSelect(
                              modalTitle: L10n.of(context).modal_select_app_bar_select_breeds_text,
                              ctx: context,
                              options: vm.breedOptions,
                              controller: _breedController,
                              vm: vm,
                              isBreeds: true,
                            ),
                      readOnly: true,
                      enabled: !vm.isLoadingBreeds && _speciesController.text.isNotEmpty,
                      decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 48,
                          maxHeight: 25,
                          minWidth: 48,
                          minHeight: 25,
                        ),
                        suffixIcon: !vm.isLoadingBreeds
                            ? Icon(Icons.keyboard_arrow_right)
                            : SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 23),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_breed_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    DatePickerWidget(
                      lastDateToday: true,
                      labelText: L10n.of(context).add_edit_pet_screen_date_of_birth_input_text,
                      controller: _dateController,
                      onFieldSubmitted: (DatePickerValue? val) {
                        _selectedDate = val;
                      },
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      controller: _genderController,
                      onTap: () => showModalSelect(
                        modalTitle: L10n.of(context).modal_select_app_bar_select_gender_text,
                        ctx: context,
                        options: genderOptions,
                        vm: vm,
                        controller: _genderController,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_gender_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      controller: _weightController,
                      maxLength: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).weight_kg,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _colorController,
                      maxLength: 20,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).add_edit_pet_screen_color_input_text,
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 4,
                      maxLength: 140,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).description,
                      ),
                    ),
                  ],
                ),
                isExpanded: this.isExpanded,
              )
            ],
          ),
          SizedBox(height: ThemeConstants.spacing(1)),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (vm.isLoadingCreatePet || vm.isLoadingEditPet)
                  ? null
                  : () {
                      _onSubmit(
                        vm: vm,
                        genderOptions: genderOptions,
                        speciesOptions: speciesOptions,
                      );
                    },
              child: vm.isLoadingCreatePet || vm.isLoadingEditPet
                  ? ThemeConstants.getButtonSpinner()
                  : Text(
                      !vm.isEditMode ? L10n.of(context).create : L10n.of(context).update,
                    ),
            ),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
              title: Text(
            !vm.isEditMode
                ? L10n.of(context).add_edit_pet_screen_app_bar_text
                : L10n.of(context).add_edit_pet_screen_app_bar_edit_text(
                    vm.pet!.name,
                  ),
          )),
          body: Scrollbar(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                cacheExtent: 1000,
                controller: _scrollController,
                itemCount: _formWidgets.length,
                padding: EdgeInsets.all(ThemeConstants.spacing(1)),
                itemBuilder: (_, i) {
                  return _formWidgets[i];
                },
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
  final dispatchLoadCreatePetThunk;
  final dispatchLoadEditPetThunk;
  final bool isLoadingCreatePet;
  final bool isLoadingEditPet;
  final bool isLoadingBreeds;
  final bool isEditMode;
  final bool error;
  final PetResDto? pet;
  final String petAvatarUrl;
  final List<ModalSelectOption<String>> breedOptions;

  _AddEditPetScreenViewModel({
    required this.dispatchLoadBreedsBySpeciesThunk,
    required this.dispatchLoadCreatePetThunk,
    required this.dispatchLoadEditPetThunk,
    required this.isLoadingBreeds,
    required this.isLoadingCreatePet,
    required this.isLoadingEditPet,
    required this.error,
    required this.breedOptions,
    required this.isEditMode,
    required this.pet,
    required this.petAvatarUrl,
  });
}
