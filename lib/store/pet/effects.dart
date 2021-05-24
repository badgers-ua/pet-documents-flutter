import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

import 'actions.dart';

Function loadPetThunk = ({
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadPet());
      try {
        final response = await Dio().authenticatedDio().get('/pet/$petId');
        final PetResDto petResDto = PetResDto.fromJson(response.data);

        store.dispatch(LoadPetSuccess(payload: petResDto));
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadPetFailure(payload: errorMsg));
      }
    };
