import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/request/edit_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/create_pet_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/string.dart';

import 'actions.dart';

Function loadEditPetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      final PetResDto? currentPet = store.state.pet.data?.petResDto;

      final String currentPetAvatar = currentPet?.avatar ?? '';

      final File? currentPetAvatarFile = currentPetAvatar.isNotEmpty
          ? await (store.state.imageUrls.data!.firstWhere((element) => element.name == currentPetAvatar).url)
              .getFileFromCachedImage()
          : null;

      final bool isAvatarChanged = currentPetAvatarFile?.path != request.avatar?.path;

      final EditPetReqDto _request = EditPetReqDto.fromCreatePetReqDto(
        dto: request,
        isAvatarChanged: isAvatarChanged,
      );

      _request.isAvatarChanged = isAvatarChanged;

      if (currentPet != null) {
        final isPetChanged = currentPet.name != _request.name ||
            currentPet.species != _request.species ||
            currentPet.breed?.id != _request.breed ||
            currentPet.gender != _request.gender ||
            currentPet.dateOfBirth != _request.dateOfBirth ||
            currentPet.colour != _request.colour ||
            currentPet.weight != _request.weight ||
            currentPet.notes != _request.notes ||
            isAvatarChanged;
        if (!isPetChanged) {
          Navigator.of(ctx).pop();
          return;
        }
      }

      store.dispatch(LoadEditPet());

      try {
        final res = await Dio().authenticatedDio(ctx: ctx).patch('/pet/$petId', data: await _request.toFormData());
        final CreatePetResDto createPetResDto = CreatePetResDto.fromJson(res.data);
        Navigator.of(ctx).pop();
        store.dispatch(LoadEditPetSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        store.dispatch(loadPetThunk(ctx: ctx, petId: petId));
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadEditPetFailure(payload: errorMsg));
      }
    };
