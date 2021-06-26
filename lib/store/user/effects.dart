import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/store/user/actions.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../constants.dart';
import '../../locator.dart';
import '../index.dart';

Function loadUserThunk = ({
  required BuildContext ctx,
  showEmailNotConfirmedError = true,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadUser());
      try {
        final response = await Dio().authenticatedDio(ctx: ctx).get('${Api.baseUrl}/profile');
        final UserResDto resDto = UserResDto.fromJson(response.data);
        store.dispatch(LoadUserSuccess(payload: resDto));
        locator<AnalyticsService>().setUserProperties(userId: resDto.id);
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        locator<AnalyticsService>().logError(errorMsg: errorMsg);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadUserFailure(payload: errorMsg));
      }
    };
