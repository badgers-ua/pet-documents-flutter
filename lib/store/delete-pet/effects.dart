import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/actions.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadDeletePetThunk = ({
  required BuildContext ctx,
  required PetResDto pet,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadDeletePet());
      try {
        if (pet.avatar != null) {
          await FirebaseConstants.deleteAvatar(ctx: ctx, currentAvatarLink: pet.avatar!);
        }
        await Dio().authenticatedDio(ctx: ctx).delete('/pet/${pet.id}');
        Navigator.of(ctx).popUntil((route) => route.isFirst);
        store.dispatch(LoadDeletePetSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        store.dispatch(ClearPetState());
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadDeletePetFailure(payload: errorMsg));
      }
    };
