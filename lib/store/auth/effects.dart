import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/refresh_token_req_dto.dart';
import 'package:pdoc/models/dto/request/sign_in_req_dto.dart';
import 'package:pdoc/models/dto/request/social_sign_in_req_dto.dart';
import 'package:pdoc/models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/screens/sign_in_screen.dart';
import 'package:pdoc/screens/tabs_screen.dart';
import 'package:pdoc/store/add-owner/actions.dart';
import 'package:pdoc/store/add-pet/actions.dart';
import 'package:pdoc/store/breeds/actions.dart';
import 'package:pdoc/store/create-event/actions.dart';
import 'package:pdoc/store/delete-event/actions.dart';
import 'package:pdoc/store/delete-pet/actions.dart';
import 'package:pdoc/store/edit-event/actions.dart';
import 'package:pdoc/store/edit-pet/actions.dart';
import 'package:pdoc/store/events/actions.dart';
import 'package:pdoc/store/pet/actions.dart';
import 'package:pdoc/store/pets/actions.dart';
import 'package:pdoc/store/remove-owner/actions.dart';
import 'package:pdoc/store/sign-up/actions.dart';
import 'package:pdoc/store/user/actions.dart';
import 'package:pdoc/store/user/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

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

Function loadAccessTokenFromRefreshTokenThunk = ({required BuildContext ctx}) => (Store<RootState> store) async {
      store.dispatch(LoadAccessToken());
      final String refreshToken = await secureStorage.read(key: 'refresh_token') ?? '';
      final String deviceToken = store.state.deviceToken.data!.deviceToken;
      final RefreshTokenReqDto dto = RefreshTokenReqDto(
        refreshToken: refreshToken,
        deviceToken: deviceToken,
      );
      try {
        final response = await Dio().post('${Api.baseUrl}/auth/refresh-token', data: dto);
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
        store.dispatch(loadUserThunk(ctx: ctx));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
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
        final response = await Dio().post('${Api.baseUrl}/auth/login', data: dto);
        final SignInResDto resDto = SignInResDto.fromJson(response.data);

        Navigator.of(ctx).pushReplacementNamed(TabsScreen.routeName);

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
        store.dispatch(loadUserThunk(ctx: ctx));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignInFailure(payload: errorMsg));
      }
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
        store.dispatch(loadUserThunk(ctx: ctx));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignInFailure(payload: errorMsg));
      }
    };

Function signOutThunk = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      clearRefreshToken();
      // TODO: Clear everything
      store.dispatch(ClearAddOwnerState());
      store.dispatch(ClearAddPetState());
      store.dispatch(ClearAuthState());
      store.dispatch(ClearBreedsState());
      store.dispatch(ClearCreateEventState());
      store.dispatch(ClearDeleteEventState());
      store.dispatch(ClearDeletePetState());
      store.dispatch(ClearEditEventState());
      store.dispatch(ClearEditPetState());
      store.dispatch(ClearEventsState());
      store.dispatch(ClearPetState());
      store.dispatch(ClearPetsState());
      store.dispatch(ClearRemoveOwnerState());
      store.dispatch(ClearSignUpState());
      store.dispatch(ClearUserState());
      GoogleSignIn().signOut();
      Navigator.of(ctx).pushReplacementNamed(SignInScreen.routeName);
    };
