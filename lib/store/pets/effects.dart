import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:redux/redux.dart';

import '../index.dart';
import 'actions.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

Function loadPetsThunk = ({
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadPets());
      try {
        final response = await Dio().authenticatedDio().get('/pets');

        // final q = response.data.map((item) => PetPreviewResDto.fromJson(item)).cast<PetPreviewResDto>().toList();

        final List<PetPreviewResDto> petPreviewList =
            response.data.map((item) => PetPreviewResDto.fromJson(item)).cast<PetPreviewResDto>().toList();
        store.dispatch(LoadPetsSuccess(payload: petPreviewList));
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadPetsFailure(payload: errorMsg));
      }
    };
