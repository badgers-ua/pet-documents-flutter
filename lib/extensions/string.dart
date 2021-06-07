import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdoc/l10n/l10n.dart';

extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  String? requiredValidator({
    required String fieldName,
    required BuildContext ctx,
  }) {
    if (this.isEmpty) {
      return L10n.of(ctx).required_validator_text(fieldName);
    }
    return null;
  }

  bool isValidPassword() {
    return this.length > 5 && this.length < 21;
  }

  bool isPasswordMatchesWith(String password) {
    return this == password;
  }

  String toBearerToken() {
    return 'Bearer $this';
  }

  Future<File> getFileFromCachedImage() async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(this);
    return file;
  }

  String calculateAge({required BuildContext ctx}) {
    if (this != '') {
      var birthDate = DateTime.tryParse(this);
      if (birthDate != null) {
        final now = new DateTime.now();

        int years = now.year - birthDate.year;
        int months = now.month - birthDate.month;
        int days = now.day - birthDate.day;

        if (months < 0 || (months == 0 && days < 0)) {
          years--;
          months += (days < 0 ? 11 : 12);
        }

        if (days < 0) {
          final monthAgo = new DateTime(now.year, now.month - 1, birthDate.day);
          days = now.difference(monthAgo).inDays + 1;
        }

        final _Age age = _Age(years: years, months: months, days: days);

        return '${age.years} ${L10n.of(ctx).age_year}, ${age.months} ${L10n.of(ctx).age_month}';
      } else {
        print('calculateAge: not a valid date');
      }
    } else {
      print('calculateAge: date is empty');
    }
    return '';
  }
}

class _Age {
  int years;
  int months;
  int days;

  _Age({this.years = 0, this.months = 0, this.days = 0});
}
