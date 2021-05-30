import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/date_picker_value.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/widgets/date_picker_widget.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';
import 'package:pdoc/extensions/string.dart';

class AddEditEventScreen extends StatefulWidget {
  static const routeName = '/add-edit-event';

  @override
  _AddEditEventScreenState createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isChecked = false;
  DatePickerValue? _selectedDate;

  bool _validateForm() {
    return _formKey.currentState != null && _formKey.currentState!.validate();
  }

  void _showEventTypeModalSelect({
    required BuildContext ctx,
    required List<ModalSelectOption> options,
  }) async {
    final widget = ModalSelectWidget(
      title: L10n.of(ctx).event_type,
      options: options,
    );

    if (Platform.isIOS) {
      final ModalSelectOption? modalSelectOption =
          await showCupertinoModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );

      if (modalSelectOption == null) {
        return;
      }

      _eventTypeController.text = modalSelectOption.label;
      _validateForm();

      return;
    }

    final ModalSelectOption? modalSelectOption =
        await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );

    if (modalSelectOption == null) {
      return;
    }

    _eventTypeController.text = modalSelectOption.label;
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    List<ModalSelectOption<EVENT>> eventOptions = EVENT.values.map((v) {
      return ModalSelectOption(
          label: getEventLabel(ctx: context, event: v), value: v);
    }).toList();

    return StoreConnector<RootState, _AddEditEventScreenViewModel>(
      converter: (store) {
        return _AddEditEventScreenViewModel(pet: store.state.pet.data);
      },
      builder: (context, _AddEditEventScreenViewModel vm) {
        if (vm.pet == null) {
          return Scaffold(
            body: Center(
              child: Text("No Pet"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
                L10n.of(context).add_edit_event_app_bar_title(vm.pet!.name)),
          ),
          body: Scrollbar(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacing(1)),
                    child: TextFormField(
                      controller: _eventTypeController,
                      validator: (v) => (v ?? '').requiredValidator(
                        fieldName: L10n.of(context).event_type,
                        ctx: context,
                      ),
                      onTap: () => _showEventTypeModalSelect(
                        ctx: context,
                        options: eventOptions,
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 48,
                          maxHeight: 25,
                          minWidth: 48,
                          minHeight: 25,
                        ),
                        suffixIcon: Icon(Icons.keyboard_arrow_right),
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).event_type,
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacing(1)),
                    child: DatePickerWidget(
                      labelText: L10n.of(context).date,
                      controller: _dateController,
                      validator: (v) => (v ?? '').requiredValidator(
                        fieldName: L10n.of(context).date,
                        ctx: context,
                      ),
                      onFieldSubmitted: (DatePickerValue? val) {
                        _selectedDate = val;
                        _validateForm();
                      },
                    ),
                  ),
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacing(1)),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 48,
                          maxHeight: 25,
                          minWidth: 48,
                          minHeight: 25,
                        ),
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context).description,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          child: Text(
                            "Receive notification",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .color,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_validateForm()) {
                          return;
                        }
                      },
                      child: Text(
                        L10n.of(context).create,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddEditEventScreenViewModel {
  final PetResDto? pet;

  _AddEditEventScreenViewModel({required this.pet});
}
