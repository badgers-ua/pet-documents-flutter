import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';

import 'l10n/l10n.dart';

class ThemeConstants {
  static final _padding = 16.0;

  static double spacing(double val) {
    return _padding * val;
  }

  static String getImageBySpecies(SPECIES species) {
    switch (species) {
      case SPECIES.CAT:
        return 'assets/images/cat.svg';
      case SPECIES.DOG:
        return 'assets/images/dog.svg';
      default:
        return 'assets/images/paw.svg';
    }
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

  static void showSnackBar({
    required BuildContext ctx,
    required String msg,
    Duration duration = const Duration(seconds: 5),
    Color color = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: color,
        action: SnackBarAction(
          label: L10n.of(ctx).scaffold_messenger_extension_dismiss_text,
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing(0.5),
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}

class FirebaseConstants {
  static Future<String?> editAvatar({
    required BuildContext ctx,
    required String currentAvatarLink,
    required File image,
  }) async {
    try {
      await FirebaseConstants.deleteAvatar(ctx: ctx, currentAvatarLink: currentAvatarLink);
      return await FirebaseConstants.uploadAvatar(ctx: ctx, image: image);
    } on FirebaseException catch (e) {
      ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).avatar_upload_error);
    }
  }

  static Future<void> deleteAvatar({
    required BuildContext ctx,
    required String currentAvatarLink,
  }) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      final Reference ref = _storage.refFromURL(currentAvatarLink);
      return await ref.delete();
    } on FirebaseException catch (e) {
      ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).avatar_upload_error);
    }
  }

  static Future<String?> uploadAvatar({
    required BuildContext ctx,
    required File image,
  }) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final String filePath = 'pet-photos/${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
    try {
      final TaskSnapshot uploadTask = await _storage.ref().child(filePath).putFile(image);
      final String imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).avatar_upload_error);
    }
  }
}

class Api {
  // Android
  static const baseUrl = 'http://10.0.2.2:5000/api/v2';
// static const baseUrl = 'http://localhost:5000/api/v2';
// static const baseUrl = 'https://p-doc.com/api/v2';
}
