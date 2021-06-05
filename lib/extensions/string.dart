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
}
