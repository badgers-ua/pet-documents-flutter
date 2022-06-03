import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';

class ChatRowWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ThemeConstants.spacing(0.5),
        right: ThemeConstants.spacing(1),
        bottom: ThemeConstants.spacing(0.5),
        left: ThemeConstants.spacing(1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Name"),
              Spacer(),
              Text("Jill"),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
