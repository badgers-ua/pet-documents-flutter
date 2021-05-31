import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadEventsThunk = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadEvents());
      try {
        final res = await Dio()
            .authenticatedDio(ctx: ctx)
            .get('/events');

        final List<EventResDto> events = res.data.map((e) => EventResDto.fromJson(e)).cast<EventResDto>().toList();

        store.dispatch(LoadEventsSuccess(payload: events));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadEventsFailure(payload: errorMsg));
      }
    };
