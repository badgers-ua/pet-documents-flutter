import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/delete-event/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../locator.dart';
import 'actions.dart';

Function loadDeleteEventThunk = ({
  required String eventId,
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadDeleteEvent());
      try {
        await Dio().authenticatedDio(ctx: ctx).delete('/event/$eventId');

        store.dispatch(LoadDeleteEventSuccess());
        store.dispatch(loadEventsThunk(ctx: ctx));
        locator<AnalyticsService>().logEventDeleted();
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      } on DioError catch (e) {
        Navigator.of(ctx).pop();
        final String errorMsg = e.getResponseError(ctx: ctx);
        locator<AnalyticsService>().logError(errorMsg: errorMsg);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadDeleteEventFailure(payload: errorMsg));
      }
    };
