import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';

class PetInfoRowWidgetProps {
  final String label;
  final String value;
  final bool isRow;

  PetInfoRowWidgetProps({
    required this.label,
    required this.value,
    this.isRow = true,
  });
}

class PetInfoRowWidget extends StatelessWidget {
  final PetInfoRowWidgetProps props;

  PetInfoRowWidget({
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ThemeConstants.spacing(0.5),
        right: ThemeConstants.spacing(1),
        bottom: ThemeConstants.spacing(0.5),
        left: ThemeConstants.spacing(1),
      ),
      child: props.isRow ? _Row(props: props) : _Column(props: props)
    );
  }
}

class _Column extends StatelessWidget {
  final PetInfoRowWidgetProps props;

  _Column({
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              props.label,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: ThemeConstants.spacing(0.5)),
            Text(
              props.value,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final PetInfoRowWidgetProps props;

  _Row({
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              props.label,
              style: Theme.of(context).textTheme.caption,
            ),
            Spacer(),
            Text(
              props.value,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.end,
            ),
            Divider(),
          ],
        ),
        Divider(),
      ],
    );
  }
}
