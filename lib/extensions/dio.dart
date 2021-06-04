import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/store/auth/effects.dart';

import '../constants.dart';
import '../main.dart';

extension AuthenticatedDio on Dio {
  Dio authenticatedDio({required BuildContext ctx}) {
    Dio dio = Dio(BaseOptions(
      baseUrl: Api.baseUrl,
      responseType: ResponseType.json,
      contentType: ContentType.json.toString(),
    ));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions, handler) {
          dio.interceptors.requestLock.lock();
          final String accessToken = MyApp.store.state.auth.data!.accessToken!;

          final int expiresAt = MyApp.store.state.auth.data!.expiresAt!;
          final int now = DateTime.now().microsecondsSinceEpoch;
          final int jsNow =
              int.parse(now.toString().substring(0, now.toString().length - 6));
          final bool expiresInFiveMins = (expiresAt - jsNow) <= 300;

          if (expiresInFiveMins) {
            MyApp.store
                .dispatch(loadAccessTokenFromRefreshTokenThunk(ctx: ctx));
          }

          requestOptions.headers[HttpHeaders.authorizationHeader] =
              accessToken.toBearerToken();
          dio.interceptors.requestLock.unlock();
          return handler.next(requestOptions);
        },
      ),
    );
    return dio;
  }
}

extension DioErrorExtension on DioError {
  String getResponseError({required BuildContext ctx}) {
    if (this.response != null) {
      final String errorMsg = this.response!.data["message"];
      return errorMsg;
    }
    final String errorMsg = this.message.isNotEmpty
        ? this.message
        : L10n.of(ctx).something_went_wrong;

    return errorMsg;
  }

  void showErrorSnackBar({
    required BuildContext ctx,
    required String errorMsg,
  }) {
    ThemeConstants.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
  }
}
