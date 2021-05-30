import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/remove_owner_req_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadRemoveOwnerThunk = ({
  required RemoveOwnerReqDto request,
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadRemoveOwner());
      try {
        await Dio()
            .authenticatedDio(ctx: ctx)
            .patch('/pet/$petId/remove-owner', data: request.toJson());
        store.dispatch(LoadRemoveOwnerSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        store.dispatch(loadPetThunk(ctx: ctx, petId: petId));
        Navigator.of(ctx).pop();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadRemoveOwnerFailure(payload: errorMsg));
      }
    };
