import 'dart:io';

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
import 'package:pdoc/extensions/string.dart';

import '../../constants.dart';
import 'actions.dart';

Function loadEditPetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
  required String petId,
  required File? newAvatar,
}) =>
    (Store<RootState> store) async {
      final PetResDto? currentPet = store.state.pet.data;

      final String currentPetAvatar = store.state.pet.data?.avatar ?? '';
      final File? currentPetAvatarFile =
          currentPetAvatar.isNotEmpty ? await currentPetAvatar.getFileFromCachedImage() : null;

      final bool isAvatarChanged = currentPetAvatarFile?.path != newAvatar?.path;

      final bool shouldUploadAvatar = isAvatarChanged && currentPetAvatar.isEmpty && newAvatar != null;
      final bool shouldEditAvatar = isAvatarChanged && currentPetAvatar.isNotEmpty && newAvatar != null;
      final bool shouldDeleteAvatar = isAvatarChanged && currentPetAvatar.isNotEmpty && newAvatar == null;

      if (currentPet != null) {
        final isPetChanged = currentPet.name != request.name ||
            currentPet.species != request.species ||
            currentPet.breed != null && currentPet.breed!.id != request.breed ||
            currentPet.gender != request.gender ||
            currentPet.dateOfBirth != request.dateOfBirth ||
            currentPet.colour != request.colour ||
            currentPet.notes != request.notes ||
            shouldUploadAvatar ||
            shouldEditAvatar ||
            shouldDeleteAvatar;
        if (!isPetChanged) {
          Navigator.of(ctx).pop();
          return;
        }
      }

      store.dispatch(LoadEditPet());

      try {
        String? newAvatarUrl;

        if (shouldUploadAvatar) {
          newAvatarUrl = (await FirebaseConstants.uploadAvatar(
                ctx: ctx,
                image: newAvatar,
              )) ??
              '';
        }

        if (shouldEditAvatar) {
          newAvatarUrl = (await FirebaseConstants.editAvatar(
                ctx: ctx,
                currentAvatarLink: currentPetAvatar,
                image: newAvatar,
              )) ??
              '';
        }

        if (shouldDeleteAvatar) {
          await FirebaseConstants.deleteAvatar(
            ctx: ctx,
            currentAvatarLink: currentPetAvatar,
          );
        }

        final bool uploadSuccess = shouldUploadAvatar && newAvatarUrl != null;
        final bool editSuccess = shouldEditAvatar && newAvatarUrl != null;
        final bool deleteSuccess = shouldDeleteAvatar;

        if (uploadSuccess || editSuccess || deleteSuccess) {
          request.avatar = newAvatarUrl;
        }

        final res = await Dio().authenticatedDio(ctx: ctx).patch('/pet/$petId', data: request.toJson());
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
