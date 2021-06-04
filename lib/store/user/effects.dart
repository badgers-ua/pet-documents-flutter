import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/user/actions.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../constants.dart';
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

        if (!resDto.isEmailConfirmed) {
          ThemeConstants.showSnackBar(
            ctx: ctx,
            msg: L10n.of(ctx).not_confirmed_email_warning,
            duration: Duration(seconds: 60),
          );
        }

        store.dispatch(LoadUserSuccess(payload: resDto));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadUserFailure(payload: errorMsg));
      }
    };
