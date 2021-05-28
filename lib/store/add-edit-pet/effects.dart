import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/create_pet_res_dto.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_profile_screen.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

import 'actions.dart';

Function loadCreatePetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadAddEditPet());
      try {
        final res = await Dio()
            .authenticatedDio()
            .post('/pet/create', data: request.toJson());
        final CreatePetResDto createPetResDto =
            CreatePetResDto.fromJson(res.data);
        store.dispatch(loadPetsThunk(ctx: ctx));
        Navigator.of(ctx).pushReplacementNamed(
          PetProfileScreen.routeName,
          arguments: PetProfileScreenProps(petId: createPetResDto.id),
        );
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadAddEditPetFailure(payload: errorMsg));
      }
    };
