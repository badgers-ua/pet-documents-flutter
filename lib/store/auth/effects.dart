import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/refresh_token_req_dto.dart';
import 'package:pdoc/models/dto/request/social_sign_in_req_dto.dart';
import 'package:pdoc/models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/store/user/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../constants.dart';
import '../index.dart';
import 'actions.dart';

Function loadAccessTokenFromRefreshTokenThunk = ({required BuildContext ctx}) => (Store<RootState> store) async {
      store.dispatch(LoadAccessToken());
      final Auth? auth = await RefreshTokenConstants.loadRefreshToken(ctx: ctx, store: store);
      if (auth == null) {
        return;
      }
      store.dispatch(
        LoadAccessTokenSuccess(
            payload: auth
        ),
      );

      if (store.state.user.data != null) {
        return;
      }
      store.dispatch(loadUserThunk(ctx: ctx));
    };

Function loadSocialSignInThunk = ({
  required BuildContext ctx,
  required SocialSignInReqDto request,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadSignIn());

      try {
        final response = await Dio().post('${Api.baseUrl}/auth/social-login', data: request);
        final SignInResDto resDto = SignInResDto.fromJson(response.data);

        Navigator.of(ctx).pushReplacementNamed(TabsScreen.routeName);

        SecureStorageConstants.setRefreshToken(resDto.refreshToken);

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
        store.dispatch(loadUserThunk(ctx: ctx));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignInFailure(payload: errorMsg));
      }
    };
