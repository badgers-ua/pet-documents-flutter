import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/refresh_token_req_dto.dart';
import 'package:pdoc/models/dto/request/sign_in_req_dto.dart';
import 'package:pdoc/models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/screens/sign_in_screen.dart';
import 'package:pdoc/screens/tabs/tabs_screen.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

import '../../constants.dart';
import '../index.dart';
import 'actions.dart';

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

setRefreshToken(String refreshToken) async {
  await secureStorage.write(
    key: 'refresh_token',
    value: refreshToken,
  );
}

clearRefreshToken() async {
  await secureStorage.delete(key: 'refresh_token');
}

Function loadAccessTokenFromRefreshTokenThunk = () =>
    (Store<RootState> store) async {
      store.dispatch(LoadAccessToken());
      final String refreshToken =
          await secureStorage.read(key: 'refresh_token') ?? '';
      final String deviceToken = store.state.deviceToken.data!.deviceToken;
      final RefreshTokenReqDto dto = RefreshTokenReqDto(
        refreshToken: refreshToken,
        deviceToken: deviceToken,
      );
      try {
        final response =
            await Dio().post('${Api.baseUrl}/auth/refresh-token', data: dto);
        final SignInResDto resDto = SignInResDto.fromJson(response.data);

        setRefreshToken(resDto.refreshToken);

        store.dispatch(
          LoadAccessTokenSuccess(
            payload: Auth(
              accessToken: resDto.accessToken,
              refreshToken: resDto.refreshToken,
              expiresAt: resDto.expiresAt,
              isAuthenticated: true,
            ),
          ),
        );
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        // ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        print('Refresh Token Error: $errorMsg');

        store.dispatch(LoadAccessTokenFailure(payload: errorMsg));
      }
    };

Function loadSignInThunk = ({
  required BuildContext ctx,
  required String email,
  required String password,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadSignIn());
      final String deviceToken = store.state.deviceToken.data!.deviceToken;

      final SignInReqDto dto = SignInReqDto(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );

      try {
        final response =
            await Dio().post('${Api.baseUrl}/auth/login', data: dto);
        final SignInResDto resDto = SignInResDto.fromJson(response.data);

        Timer(Duration(milliseconds: 50), () {
          Navigator.of(ctx).pushReplacementNamed(TabsScreen.routeName);
        });

        setRefreshToken(resDto.refreshToken);

        store.dispatch(
          LoadSignInSuccess(
            payload: Auth(
              accessToken: resDto.accessToken,
              refreshToken: resDto.refreshToken,
              expiresAt: resDto.expiresAt,
              isAuthenticated: true,
            ),
          ),
        );
        // store.dispatch(SetUserState(payload: User.getUserFromToken(auth.idToken!)));
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadSignInFailure(payload: errorMsg));
      }
    };

Function signOutThunk = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      clearRefreshToken();
      store.dispatch(ClearAuthState());
      Navigator.of(ctx).pushReplacementNamed(SignInScreen.routeName);
    };
