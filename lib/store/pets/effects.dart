import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:redux/redux.dart';

import '../../locator.dart';
import '../index.dart';
import 'actions.dart';
import 'package:pdoc/extensions/dio.dart';

Function loadPetsThunk = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadPets());
      try {
        final response = await Dio().authenticatedDio(ctx: ctx).get('/pets');
        final List<PetPreviewResDto> petPreviewList =
            response.data.map((item) => PetPreviewResDto.fromJson(item)).cast<PetPreviewResDto>().toList();
        store.dispatch(LoadPetsSuccess(payload: petPreviewList));
        locator<AnalyticsService>().logPetsLoaded();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        locator<AnalyticsService>().logError(errorMsg: errorMsg);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadPetsFailure(payload: errorMsg));
      }
    };
