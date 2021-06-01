import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_event_req_dto.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadEditEventThunk = ({
  required CreateEventReqDto request,
  required BuildContext ctx,
  required String eventId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadEditEvent());
      try {
        await Dio()
            .authenticatedDio(ctx: ctx)
            .patch('/event/$eventId', data: request.toJson());

        store.dispatch(LoadEditEventSuccess());
        store.dispatch(loadEventsThunk(ctx: ctx));
        Navigator.of(ctx).pop();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadEditEventFailure(payload: errorMsg));
      }
    };
