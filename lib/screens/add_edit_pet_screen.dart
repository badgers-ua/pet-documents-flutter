import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';

class AddEditPetScreen extends StatelessWidget {
  static const routeName = '/pet-create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).add_edit_pet_screen_app_bar_text)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            child: Text("Create new one"),
          ),
        ),
      ),
    );
  }
}
