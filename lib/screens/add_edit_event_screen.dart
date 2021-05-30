import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';

class AddEditEventScreen extends StatelessWidget {
  static const routeName = '/add-edit-event';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventTypeController = TextEditingController();

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
        return;
      }

      final ModalSelectOption? modalSelectOption =
      await showMaterialModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );
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
                padding: EdgeInsets.all(ThemeConstants.spacing(1)),
                children: [
                  TextFormField(
                    controller: _eventTypeController,
                    onTap: () =>  _showEventTypeModalSelect(
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
                      labelText:
                      L10n.of(context).event_type,
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
