import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/create_pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

import 'actions.dart';

Function loadEditPetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadEditPet());
      try {
        final res = await Dio()
            .authenticatedDio()
            .patch('/pet/$petId', data: request.toJson());
        final CreatePetResDto createPetResDto =
            CreatePetResDto.fromJson(res.data);
        store.dispatch(LoadEditPetSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        store.dispatch(loadPetThunk(ctx: ctx, petId: petId));
        Navigator.of(ctx).pop();
      } catch (e) {
        print(1);
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadEditPetFailure(payload: errorMsg));
      }
    };
