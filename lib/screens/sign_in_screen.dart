import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdoc/constants.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Pet Documents")),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ThemeConstants.spacing(1)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                SvgPicture.asset(
                  'assets/images/circle-paw.svg',
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  height: ThemeConstants.spacing(2),
                ),
                Text(
                  "Sign In",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(
                  height: ThemeConstants.spacing(1),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Sign in"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
