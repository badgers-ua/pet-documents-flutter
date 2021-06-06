import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/extensions/string.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/store/auth/actions.dart';

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
        onRequest: (RequestOptions requestOptions, handler) async {
          dio.interceptors.requestLock.lock();

          final int expiresAt = MyApp.store.state.auth.data!.expiresAt!;
          final int now = DateTime.now().microsecondsSinceEpoch;
          final int jsNow = int.parse(now.toString().substring(0, now.toString().length - 6));
          final bool expiresInFiveMins = (expiresAt - jsNow) <= 300;
          final String currentToken = MyApp.store.state.auth.data!.accessToken!;

          String accessToken = currentToken;

          if (expiresInFiveMins) {
            final Auth? auth = await RefreshTokenConstants.loadRefreshToken(store: MyApp.store, ctx: ctx);

            if (auth == null) {
              return;
            }

            MyApp.store.dispatch(
              LoadAccessTokenSuccess(
                  payload: auth
              ),
            );

            accessToken = auth.accessToken!;
          }

          requestOptions.headers[HttpHeaders.authorizationHeader] = accessToken.toBearerToken();
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
    final String errorMsg = this.message.isNotEmpty ? this.message : L10n.of(ctx).something_went_wrong;

    return errorMsg;
  }

  void showErrorSnackBar({
    required BuildContext ctx,
    required String errorMsg,
  }) {
    ThemeConstants.showSnackBar(ctx: ctx, msg: errorMsg);
  }
}
