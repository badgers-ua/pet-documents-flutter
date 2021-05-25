import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';

class AddEditPetScreen extends StatelessWidget {
  static const routeName = '/pet-create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(L10n.of(context).add_edit_pet_screen_app_bar_text)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(ThemeConstants.spacing(1)),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Species",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Breed",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Gender",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Date of birth",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Color",
                      ),
                    ),
                    SizedBox(height: ThemeConstants.spacing(1)),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
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
  }
}
