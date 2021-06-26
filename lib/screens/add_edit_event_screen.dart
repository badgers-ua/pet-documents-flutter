import 'dart:io' show Platform;
import 'package:intl/intl.dart' as intl;
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
import 'package:pdoc/store/delete-event/effects.dart';
import 'package:pdoc/store/edit-event/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/widgets/confirmation_dialog_widget.dart';
import 'package:pdoc/widgets/date_picker_widget.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';
import 'package:pdoc/extensions/string.dart';

class AddEditEventScreenProps {
  final EventResDto? event;

  AddEditEventScreenProps({required this.event});
}

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
  bool _isNotificationFieldEnabled = false;
  DatePickerValue? _selectedDate;

  bool _validateForm() {
    return _formKey.currentState != null && _formKey.currentState!.validate();
  }

  void _presetForm({
    required BuildContext ctx,
    required EventResDto event,
    required List<ModalSelectOption<EVENT>> eventOptions,
    required _AddEditEventScreenViewModel vm,
  }) {
    if (_validateForm()) {
      return;
    }
    _eventTypeController.text = eventOptions.firstWhere((element) => element.value == event.type).label;

    final DateTime eventDate = DateTime.parse(event.date).toLocal();
    final String formattedDate =
        intl.DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(eventDate).toString();
    _dateController.text = formattedDate;
    _setSelectedDate(datePickerValue: DatePickerValue(dateTime: eventDate, formattedDate: formattedDate));

    if (event.description != null) {
      _descriptionController.text = event.description!;
    }

    _isNotification = event.isNotification;
  }

  _setSelectedDate({required DatePickerValue? datePickerValue}) {
    _selectedDate = datePickerValue;
    if (datePickerValue == null) {
      return;
    }
    final bool isPastOrTodayDate = !DateTime.now().difference(datePickerValue.dateTime).isNegative;
    if (!isPastOrTodayDate) {
      setState(() {
        this._isNotificationFieldEnabled = true;
      });
      return;
    }
    setState(() {
      this._isNotificationFieldEnabled = false;
      this._isNotification = false;
    });
  }

  void _handleSubmit({
    required BuildContext ctx,
    required PetResDto pet,
    required List<ModalSelectOption> options,
    required _AddEditEventScreenViewModel vm,
  }) {
    final EVENT selectedType = options.firstWhere((element) => element.label == _eventTypeController.text).value;

    final CreateEventReqDto request = CreateEventReqDto(
      petId: pet.id,
      type: selectedType,
      date: _selectedDate!.dateTime.toIso8601String(),
      isNotification: _isNotification,
    );

    if (_descriptionController.text.isNotEmpty) {
      request.description = _descriptionController.text;
    }

    if (vm.isEditMode) {
      vm.dispatchLoadEditEventThunk(ctx: ctx, request: request, eventId: vm.event!.id);
      return;
    }

    vm.dispatchLoadCreateEventThunk(
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
      final ModalSelectOption? modalSelectOption = await showCupertinoModalBottomSheet(
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

    final ModalSelectOption? modalSelectOption = await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );

    if (modalSelectOption == null) {
      return;
    }

    _eventTypeController.text = modalSelectOption.label;
    _validateForm();
  }

  Future<void> _showDeleteEventConfirmationDialog({
    required BuildContext ctx,
    required _AddEditEventScreenViewModel vm,
  }) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmationDialogWidget(
          title: L10n.of(context).delete_event,
          content: L10n.of(context).delete_event_warning,
          enabled: !vm.isLoadingDeleteEvent,
          onSubmit: () {
            vm.dispatchDeleteEventThunk(
              ctx: ctx,
              eventId: vm.event!.id,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final AddEditEventScreenProps props =
        (arguments ?? AddEditEventScreenProps(event: null)) as AddEditEventScreenProps;

    List<ModalSelectOption<EVENT>> eventOptions = EVENT.values.map((v) {
      return ModalSelectOption(label: getEventLabel(ctx: context, event: v), value: v);
    }).toList();

    return StoreConnector<RootState, _AddEditEventScreenViewModel>(
      converter: (store) {
        return _AddEditEventScreenViewModel(
          isEditMode: props.event != null,
          event: props.event,
          pet: store.state.pet.data!.petResDto,
          error: store.state.pet.errorMessage.isNotEmpty,
          isLoadingCreateEvent: store.state.createEvent.isLoading,
          isLoadingEditEvent: store.state.editEvent.isLoading,
          isLoadingDeleteEvent: store.state.deleteEvent.isLoading,
          dispatchLoadCreateEventThunk: ({
            required BuildContext ctx,
            required CreateEventReqDto request,
          }) {
            return store.dispatch(loadCreateEventThunk(
              request: request,
              ctx: ctx,
            ));
          },
          dispatchLoadEditEventThunk: ({
            required BuildContext ctx,
            required CreateEventReqDto request,
            required String eventId,
          }) {
            return store.dispatch(loadEditEventThunk(
              request: request,
              ctx: ctx,
              eventId: eventId,
            ));
          },
          dispatchDeleteEventThunk: ({
            required BuildContext ctx,
            required String eventId,
          }) {
            return store.dispatch(loadDeleteEventThunk(
              ctx: ctx,
              eventId: eventId,
            ));
          },
        );
      },
      builder: (context, _AddEditEventScreenViewModel vm) {
        if (vm.isEditMode) {
          _presetForm(
            event: vm.event!,
            ctx: context,
            eventOptions: eventOptions,
            vm: vm,
          );
        }

        if (vm.error) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(L10n.of(context).something_went_wrong),
            ),
          );
        }

        Widget _renderAppBarActionButtons({required _AddEditEventScreenViewModel vm}) {
          if (!vm.isEditMode) {
            return Container();
          }
          if (!vm.isLoadingDeleteEvent) {
            return IconButton(
              onPressed: () {
                _showDeleteEventConfirmationDialog(ctx: context, vm: vm);
              },
              icon: Icon(Icons.delete),
            );
          }

          return Align(
            child: Container(
              margin: EdgeInsets.only(right: ThemeConstants.spacing(1)),
              height: 18,
              width: 18,
              child: Opacity(
                opacity: 0.3,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              !vm.isEditMode
                  ? L10n.of(context).add_event_app_bar_title(vm.pet!.name)
                  : L10n.of(context).edit_event_app_bar_title(vm.pet!.name),
            ),
            actions: [
              _renderAppBarActionButtons(vm: vm),
            ],
          ),
          body: Scrollbar(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
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
                    padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
                    child: DatePickerWidget(
                      lastDateToday: false,
                      labelText: L10n.of(context).date,
                      controller: _dateController,
                      validator: (v) => (v ?? '').requiredValidator(
                        fieldName: L10n.of(context).date,
                        ctx: context,
                      ),
                      onFieldSubmitted: (DatePickerValue? val) {
                        _setSelectedDate(datePickerValue: val);
                        _validateForm();
                      },
                    ),
                  ),
                  SizedBox(height: ThemeConstants.spacing(1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
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
                  _isNotificationFieldEnabled
                      ? Container(
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!this._isNotificationFieldEnabled) {
                                      return;
                                    }
                                    setState(() {
                                      _isNotification = !_isNotification;
                                    });
                                  },
                                  child: Text(
                                    L10n.of(context).receive_notification,
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                          color: Theme.of(context).textTheme.caption!.color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: ThemeConstants.spacing(1)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (vm.isLoadingCreateEvent || vm.isLoadingEditEvent)
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
                      child: (vm.isLoadingCreateEvent || vm.isLoadingEditEvent)
                          ? ThemeConstants.getButtonSpinner()
                          : Text(
                              !vm.isEditMode ? L10n.of(context).create : L10n.of(context).update,
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
  final EventResDto? event;
  final bool isLoadingCreateEvent;
  final bool isLoadingEditEvent;
  final bool isLoadingDeleteEvent;
  final bool isEditMode;
  final bool error;
  final dispatchLoadCreateEventThunk;
  final dispatchLoadEditEventThunk;
  final dispatchDeleteEventThunk;

  _AddEditEventScreenViewModel({
    required this.pet,
    required this.event,
    required this.isLoadingCreateEvent,
    required this.isLoadingEditEvent,
    required this.isEditMode,
    required this.isLoadingDeleteEvent,
    required this.error,
    required this.dispatchLoadCreateEventThunk,
    required this.dispatchLoadEditEventThunk,
    required this.dispatchDeleteEventThunk,
  });
}
