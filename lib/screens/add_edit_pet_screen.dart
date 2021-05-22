import 'package:flutter/material.dart';

class AddEditPetScreen extends StatelessWidget {
  static const routeName = '/pet-create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create pet")),
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
