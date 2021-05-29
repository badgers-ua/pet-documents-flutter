import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdoc/models/date_picker_value.dart';

class DatePickerWidget extends StatelessWidget {
  final String labelText;
  final ValueChanged<DatePickerValue>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;

  DatePickerWidget({
    required this.labelText,
    required this.controller,
    this.onFieldSubmitted,
    this.validator,
  });

  final FocusNode focusNode = FocusNode();

  Future<void> _showDialog(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 300,
            width: 300,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(
                Duration(
                    days:
                    DateTime.now().difference(DateTime(1970, 1, 1)).inDays),
              ),
              lastDate: DateTime.now(),
              onDateChanged: (DateTime v) {
                Navigator.of(ctx).pop();

                final String formattedDate =
                // TODO: Users local format
                intl.DateFormat('dd/MM/yyyy').format(v).toString();
                controller.text = formattedDate;
                if (onFieldSubmitted != null) {
                  onFieldSubmitted!(
                    DatePickerValue(dateTime: v, formattedDate: formattedDate),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            suffixIconConstraints: BoxConstraints(
                maxWidth: 48,
                maxHeight: 25,
                minWidth: 48,
                minHeight: 25),
            suffixIcon: SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(right: 23),
                child: Icon(Icons.calendar_today_rounded),
              ),
            ),
            border: OutlineInputBorder(),
            labelText: labelText,
          ),
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          onTap: () {
            _showDialog(context);
          },
        ),
      ],
    );
  }
}