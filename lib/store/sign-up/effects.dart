import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/sign_up_req_dto.dart';
import 'package:pdoc/models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/store/auth/actions.dart';
import 'package:pdoc/store/auth/effects.dart';
import 'package:pdoc/store/user/effects.dart';
import 'package:redux/redux.dart';

import '../../constants.dart';
import '../index.dart';
import 'actions.dart';
import 'package:pdoc/extensions/dio.dart';

Function loadSignUpThunk = ({
  required BuildContext ctx,
  required SignUpReqDto request,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadSignUp());
      try {
        final response = await Dio().post('${Api.baseUrl}/auth/register', data: request.toJson());
        final SignInResDto signInResDto = SignInResDto.fromJson(response.data);
        setRefreshToken(signInResDto.refreshToken);
        store.dispatch(LoadSignUpSuccess());
        store.dispatch(
          LoadSignInSuccess(
            payload: Auth(
              accessToken: signInResDto.accessToken,
              refreshToken: signInResDto.refreshToken,
              expiresAt: signInResDto.expiresAt,
              isAuthenticated: true,
            ),
          ),
        );
        store.dispatch(loadUserThunk(
          ctx: ctx,
          loadUserThunk: false,
        ));
        Navigator.of(ctx).pushReplacementNamed(TabsScreen.routeName);
        ThemeConstants.showSnackBar(
          ctx: ctx,
          msg: L10n.of(ctx).confirmation_link_sent,
          duration: Duration(seconds: 10),
          color: Colors.green,
        );
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignUpFailure(payload: errorMsg));
      }
    };
