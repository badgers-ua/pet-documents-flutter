import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_event_req_dto.dart';
import 'package:pdoc/store/events/actions.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadCreateEventThunk = ({
  required CreateEventReqDto request,
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadCreateEvent());
      try {
        await Dio()
            .authenticatedDio(ctx: ctx)
            .post('/event/create', data: request.toJson());

        store.dispatch(LoadCreateEventSuccess());
        store.dispatch(loadEventsThunk(ctx: ctx));
        Navigator.of(ctx).pop();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadCreateEventFailure(payload: errorMsg));
      }
    };
