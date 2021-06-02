import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/actions.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadDeletePetThunk = ({
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadDeletePet());
      try {
        await Dio().authenticatedDio(ctx: ctx).delete('/pet/$petId');
        store.dispatch(LoadDeletePetSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        Navigator.of(ctx).popUntil((route) => route.isFirst);
        store.dispatch(ClearPetState());
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadDeletePetFailure(payload: errorMsg));
      }
    };
