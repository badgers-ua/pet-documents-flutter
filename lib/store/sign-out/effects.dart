import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/request/sign_out_req_dto.dart';
import 'package:pdoc/services/crashlitycs_service.dart';
import 'package:pdoc/ui/screens/sign_in_screen.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/store/add-owner/actions.dart';
import 'package:pdoc/store/add-pet/actions.dart';
import 'package:pdoc/store/auth/actions.dart';
import 'package:pdoc/store/breeds/actions.dart';
import 'package:pdoc/store/create-event/actions.dart';
import 'package:pdoc/store/delete-event/actions.dart';
import 'package:pdoc/store/delete-pet/actions.dart';
import 'package:pdoc/store/edit-event/actions.dart';
import 'package:pdoc/store/edit-pet/actions.dart';
import 'package:pdoc/store/events/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/actions.dart';
import 'package:pdoc/store/pets/actions.dart';
import 'package:pdoc/store/remove-owner/actions.dart';
import 'package:pdoc/store/user/actions.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../locator.dart';
import 'actions.dart';

Function loadSignOutThunk = ({
  required BuildContext ctx,
  required SignOutReqDto request,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadSignOut());
      try {
        await Dio().authenticatedDio(ctx: ctx).post('/auth/sign-out', data: request.toJson());
        await GoogleSignIn().signOut();
        store.dispatch(LoadSignOutSuccess());
        Navigator.of(ctx).pushReplacementNamed(SignInScreen.routeName);
        ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
        store.dispatch(_clearStore(ctx: ctx));
        locator<AnalyticsService>().logLogout();
        locator<AnalyticsService>().removeUserId();
        locator<CrashlyticsService>().removeUserIdentifier();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        locator<AnalyticsService>().logError(errorMsg: errorMsg);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadSignOutFailure(payload: errorMsg));
      }
    };

Function _clearStore = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        locator<AnalyticsService>().logError(errorMsg: L10n.of(ctx).something_went_wrong);
        ThemeConstants.showSnackBar(ctx: ctx, msg: L10n.of(ctx).something_went_wrong);
      } finally {
        SecureStorageConstants.clearRefreshToken();
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
        store.dispatch(ClearUserState());
      }
    };
