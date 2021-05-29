import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/add_owner_req_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

import 'actions.dart';

Function loadAddOwnerThunk = ({
  required AddOwnerReqDto request,
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadAddOwner());
      try {
        await Dio()
            .authenticatedDio()
            .patch('/pet/$petId/add-owner', data: request.toJson());
        store.dispatch(LoadAddOwnerSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        store.dispatch(loadPetThunk(ctx: ctx, petId: petId));
        Navigator.of(ctx).pop();
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadAddOwnerFailure(payload: errorMsg));
      }
    };