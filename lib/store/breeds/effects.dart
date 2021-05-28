import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';
import 'package:pdoc/store/breeds/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';

import 'package:pdoc/extensions/dio.dart';
import 'package:pdoc/extensions/scaffold_messenger.dart';

Function loadBreedsBySpeciesThunk = ({
  required BuildContext ctx,
  required SPECIES species,
}) =>
    (Store<RootState> store) async {
      final contains = store.state.breeds.data!.containsKey(species);

      if (contains) {
        return;
      }

      store.dispatch(LoadBreeds());
      try {
        final response = await Dio()
            .authenticatedDio()
            .get('/static/breeds/${species.index}');
        final List<StaticResDto> breeds =
            response.data.map((item) => StaticResDto.fromJson(item)).cast<StaticResDto>().toList();
        final Map<SPECIES, List<StaticResDto>> payload = {species: breeds};
        store.dispatch(LoadBreedsSuccess(payload: payload));
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        ScaffoldMessenger(child: Container()).showErrorSnackBar(ctx, errorMsg);

        store.dispatch(LoadBreedsFailure(payload: errorMsg));
      }
    };
