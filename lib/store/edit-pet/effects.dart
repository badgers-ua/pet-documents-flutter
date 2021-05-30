import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/create_pet_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadEditPetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
  final PetResDto? currentPet = store.state.pet.data;
  if (currentPet != null) {
    final isPetChanged = currentPet.name != request.name
        || currentPet.species != request.species
        || currentPet.breed != null && currentPet.breed!.id != request.breed
        || currentPet.gender != request.gender
        || currentPet.dateOfBirth != request.dateOfBirth
        || currentPet.colour != request.colour
        || currentPet.notes != request.notes;
    if (!isPetChanged) {
      Navigator.of(ctx).pop();
      return;
    }
  }

  store.dispatch(LoadEditPet());
  try {
    final res = await Dio()
        .authenticatedDio(ctx: ctx)
        .patch('/pet/$petId', data: request.toJson());
    final CreatePetResDto createPetResDto =
    CreatePetResDto.fromJson(res.data);
    store.dispatch(LoadEditPetSuccess());
    store.dispatch(loadPetsThunk(ctx: ctx));
    store.dispatch(loadPetThunk(ctx: ctx, petId: petId));
    Navigator.of(ctx).pop();
  } on DioError catch (e) {
    final String errorMsg = e.getResponseError(ctx: ctx);
    e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
    store.dispatch(LoadEditPetFailure(payload: errorMsg));
  }
};
