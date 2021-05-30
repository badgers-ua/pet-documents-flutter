import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadPetThunk = ({
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadPet());
      try {
        final response = await Dio().authenticatedDio(ctx: ctx).get('/pet/$petId');
        final PetResDto petResDto = PetResDto.fromJson(response.data);

        store.dispatch(LoadPetSuccess(payload: petResDto));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadPetFailure(payload: errorMsg));
      }
    };
