import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/index.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootStore, _SettingsScreenViewModel>(
      converter: (store) {
        return _SettingsScreenViewModel(
          dispatchSignOut: () => store.dispatch(signOutThunk(ctx: context)),
        );
      },
      builder: (context, _SettingsScreenViewModel vm) {
        return ListView(
          children: [
            Container(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                onPressed: vm.dispatchSignOut,
                child: Text(L10n.of(context).settings_screen_sign_out_button_text),
              ),
            )
          ],
        );
      },
    );
  }
}

class _SettingsScreenViewModel {
  final dispatchSignOut;

  _SettingsScreenViewModel({
    required this.dispatchSignOut,
  });
}
