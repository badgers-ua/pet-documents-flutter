import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/request/create_pet_req_dto.dart';
import 'package:pdoc/models/dto/response/create_pet_res_dto.dart';
import 'package:pdoc/ui/screens/tabs/pet_profile/pet_profile_screen.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../locator.dart';
import 'actions.dart';

Function loadCreatePetThunk = ({
  required CreatePetReqDto request,
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadAddPet());
      try {
        final res = await Dio().authenticatedDio(ctx: ctx).post('/pet/create', data: await request.toFormData());
        final CreatePetResDto createPetResDto = CreatePetResDto.fromJson(res.data);
        store.dispatch(LoadAddPetSuccess());
        store.dispatch(loadPetsThunk(ctx: ctx));
        locator<AnalyticsService>().logPetCreated(hasAvatar: request.avatar != null);
        Navigator.of(ctx).pushReplacementNamed(
          PetProfileScreen.routeName,
          arguments: PetProfileScreenProps(petId: createPetResDto.id),
        );
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        locator<AnalyticsService>().logError(errorMsg: errorMsg);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadAddPetFailure(payload: errorMsg));
      }
    };
