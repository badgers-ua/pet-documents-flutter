import 'package:flutter/material.dart';

class EventCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child:  InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: ListTile(
          leading: FlutterLogo(size: 72.0),
          title: Text('Three-line ListTile'),
          subtitle: Text(
              'A sufficiently long subtitle warrants three lines.'
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
