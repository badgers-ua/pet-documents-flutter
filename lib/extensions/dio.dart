import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pdoc/extensions/string.dart';

import '../constants.dart';
import '../main.dart';

extension AuthenticatedDio on Dio {
  Dio authenticatedDio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: Api.baseUrl,
      responseType: ResponseType.json,
      contentType: ContentType.json.toString(),
    ));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions, handler) {
          dio.interceptors.requestLock.lock();
          final String accessToken =
              MainScreen.store.state.auth.data!.accessToken!;
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
