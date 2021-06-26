import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/dto/request/social_sign_in_req_dto.dart';
import 'package:pdoc/models/dto/response/sign_in_res_dto.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/store/user/effects.dart';
import 'package:pdoc/ui/screens/tabs_screen.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../constants.dart';
import '../../locator.dart';
import '../index.dart';
import 'actions.dart';

Function loadGoogleFirebaseAuth = ({required BuildContext ctx}) => (Store<RootState> store) async {
      try {
        final PLATFORM? platform = getPlatformByPlatformName(osName: Platform.operatingSystem);

        final String deviceToken = store.state.deviceToken.data?.deviceToken ?? '';

        if (deviceToken.isEmpty || platform == null) {
          ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).something_went_wrong);
          return;
        }

        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          return;
        }

        final GoogleSignInAccount? account = googleUser;

        if (account == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        final SocialSignInReqDto request = SocialSignInReqDto(
          token: googleAuth.idToken!,
          socialType: SOCIAL_TYPE.GOOGLE,
          email: account.email,
          firstName: account.displayName!.split(" ")[0],
          lastName: account.displayName!.split(" ")[1],
          deviceToken: deviceToken,
          platform: platform,
          avatar: account.photoUrl!,
        );

        locator<AnalyticsService>().logFirebaseGoogleLogin();

        store.dispatch(loadSocialSignInThunk(ctx: ctx, request: request));
      } catch (e) {
        locator<AnalyticsService>().logError(errorMsg: L10n.of(ctx).something_went_wrong);
        ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).something_went_wrong);
      }
    };

Function loadAccessTokenFromRefreshTokenThunk = ({required BuildContext ctx}) => (Store<RootState> store) async {
      store.dispatch(LoadAccessToken());
      final Auth? auth = await RefreshTokenConstants.loadRefreshToken(ctx: ctx, store: store);
      if (auth == null) {
        return;
      }
      store.dispatch(
        LoadAccessTokenSuccess(payload: auth),
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
        locator<AnalyticsService>().logGoogleLogin();
        store.dispatch(loadUserThunk(ctx: ctx));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignInFailure(payload: errorMsg));
      }
    };
