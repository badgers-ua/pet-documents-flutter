import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/request/add_owner_req_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/add-owner/effects.dart';
import 'package:pdoc/store/index.dart';

class AddOwnerDialogWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final PetResDto pet;

  AddOwnerDialogWidget({required this.pet});

  bool _validateForm() {
    return _formKey.currentState != null && _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _AddOwnerDialogWidgetViewModel>(
      converter: (store) {
        return _AddOwnerDialogWidgetViewModel(
          isLoadingAddOwner: store.state.addOwner.isLoading,
          dispatchLoadAddOwnerThunk: ({
            required BuildContext ctx,
            required String email,
          }) =>
              store.dispatch(
            loadAddOwnerThunk(
              ctx: ctx,
              request: AddOwnerReqDto(ownerEmail: _emailController.value.text),
              petId: pet.id,
            ),
          ),
        );
      },
      distinct: true,
      builder: (context, _AddOwnerDialogWidgetViewModel vm) {
        return AlertDialog(
          title: Text(L10n.of(context).add_owner),
          content: Container(
            height: 230,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  L10n.of(context)
                      .add_owner_dialog_widget_description1_text(pet.name),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  L10n.of(context).add_owner_dialog_widget_description2_text,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: ThemeConstants.spacing(1)),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 80,
                    child: TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.go,
                      validator: (input) => input!.isValidEmail()
                          ? null
                          : L10n.of(context).sign_in_screen_invalid_email_text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: L10n.of(context)
                            .sign_in_screen_email_text_field_text,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: vm.isLoadingAddOwner ? null : () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        L10n.of(context).cancel_text,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: vm.isLoadingAddOwner
                          ? null
                          : () {
                              if (!_validateForm()) {
                                return;
                              }
                              vm.dispatchLoadAddOwnerThunk(
                                ctx: context,
                                email: _emailController.text.trim(),
                              );
                            },
                      child: vm.isLoadingAddOwner
                          ? ThemeConstants.getButtonSpinner()
                          : Text(
                              L10n.of(context).done_text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddOwnerDialogWidgetViewModel {
  final bool isLoadingAddOwner;
  final dispatchLoadAddOwnerThunk;

  _AddOwnerDialogWidgetViewModel({
    required this.isLoadingAddOwner,
    required this.dispatchLoadAddOwnerThunk,
  });
}
