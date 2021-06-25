import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/auth/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';

import 'l10n/l10n.dart';
import 'models/auth.dart';
import 'models/dto/request/refresh_token_req_dto.dart';
import 'models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/extensions/dio.dart';

class SecureStorageConstants {
  static Future<void> setRefreshToken(String refreshToken) async {
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
    return await _secureStorage.write(
      key: 'refresh_token',
      value: refreshToken,
    );
  }

  static Future<String> getRefreshToken() async {
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
    return (await _secureStorage.read(key: 'refresh_token')) ?? '';
  }

  static Future<void> clearRefreshToken() async {
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
    return await _secureStorage.delete(key: 'refresh_token');
  }
}

class RefreshTokenConstants {
  static Future<Auth?> loadRefreshToken({
    required Store<RootState> store,
    required BuildContext ctx,
  }) async {
    final String refreshToken = await SecureStorageConstants.getRefreshToken();
    final String deviceToken = store.state.deviceToken.data!.deviceToken;
    final RefreshTokenReqDto dto = RefreshTokenReqDto(
      refreshToken: refreshToken,
      deviceToken: deviceToken,
    );
    try {
      final response = await Dio().post('${Api.baseUrl}/auth/refresh-token', data: dto.toJson());
      final SignInResDto resDto = SignInResDto.fromJson(response.data);

      await SecureStorageConstants.setRefreshToken(resDto.refreshToken);

      final Auth auth = Auth(
        accessToken: resDto.accessToken,
        refreshToken: resDto.refreshToken,
        expiresAt: resDto.expiresAt,
        isAuthenticated: true,
      );

      return auth;
    } on DioError catch (e) {
      final String errorMsg = e.getResponseError(ctx: ctx);
      e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
      store.dispatch(LoadAccessTokenFailure(payload: errorMsg));
    }
  }
}

class ThemeConstants {
  static final _padding = 16.0;

  static double spacing(double val) {
    return _padding * val;
  }

  static String getImageBySpecies(SPECIES? species) {
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

class Api {
  // Android
  static const baseUrl = 'http://10.0.2.2:5000/api/v2';
// static const baseUrl = 'http://localhost:5000/api/v2';
// static const baseUrl = 'https://p-doc.com/api/v2';
}
