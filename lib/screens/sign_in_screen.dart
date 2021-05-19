import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Welcome")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pet Documents',
            ),
          ],
        ),
      ),
    );
  }
}