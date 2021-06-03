import 'package:flutter/material.dart';

class ThemeConstants {
  static final _padding = 16.0;

  static double spacing(double val) {
    return _padding * val;
  }

  static Widget getButtonSpinner() {
    return Opacity(
      opacity: 0.3,
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class Api {
  // Android
  // static const baseUrl = 'http://10.0.2.2:5000/api/v2';
  // static const baseUrl = 'http://localhost:5000/api/v2';
  static const baseUrl = 'https://p-doc.com/api/v2';
}
