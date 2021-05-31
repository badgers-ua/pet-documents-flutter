import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/date_picker_value.dart';
import 'package:pdoc/models/dto/request/create_event_req_dto.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/create-event/effects.dart';
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
  bool _isNotification = false;
  DatePickerValue? _selectedDate;

  bool _validateForm() {
    return _formKey.currentState != null && _formKey.currentState!.validate();
  }

  void _handleSubmit({
    required BuildContext ctx,
    required PetResDto pet,
    required List<ModalSelectOption> options,
    required _AddEditEventScreenViewModel vm,
  }) {
    final EVENT selectedType = options
        .firstWhere((element) => element.label == _eventTypeController.text)
        .value;

    final CreateEventReqDto request = CreateEventReqDto(
      petId: pet.id,
      type: selectedType,
      date: _selectedDate!.dateTime.toIso8601String(),
      isNotification: _isNotification,
    );

    if (_descriptionController.text.isNotEmpty) {
      request.description = _descriptionController.text;
    }

    vm.dispatchLoadEventsThunk(
      ctx: ctx,
      request: request,
    );
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
        return _AddEditEventScreenViewModel(
          isEditMode: false,
          pet: store.state.pet.data,
          isLoadingCreateEvent: store.state.createEvent.isLoading,
          dispatchLoadEventsThunk: ({
            required BuildContext ctx,
            required CreateEventReqDto request,
          }) {
            return store.dispatch(loadCreateEventThunk(
              request: request,
              ctx: ctx,
            ));
          },
        );
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
                      lastDateToday: false,
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
                          value: _isNotification,
                          onChanged: (bool? value) {
                            setState(() {
                              _isNotification = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isNotification = !_isNotification;
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
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacing(1)),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoadingCreateEvent
                          ? null
                          : () {
                              if (!_validateForm()) {
                                return;
                              }
                              _handleSubmit(
                                pet: vm.pet!,
                                ctx: context,
                                options: eventOptions,
                                vm: vm,
                              );
                            },
                      child: vm.isLoadingCreateEvent
                          ? ThemeConstants.getButtonSpinner()
                          : Text(
                              !vm.isEditMode
                                  ? L10n.of(context).create
                                  : L10n.of(context).update,
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
  final bool isLoadingCreateEvent;
  final bool isEditMode;
  final dispatchLoadEventsThunk;

  _AddEditEventScreenViewModel({
    required this.pet,
    required this.isLoadingCreateEvent,
    required this.isEditMode,
    required this.dispatchLoadEventsThunk,
  });
}
