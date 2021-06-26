import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/image_url.dart';
import 'package:pdoc/models/pet_state.dart';
import 'package:pdoc/store/image-urls/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadPetThunk = ({
  required BuildContext ctx,
  required String petId,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadPet());
      try {
        final response = await Dio().authenticatedDio(ctx: ctx).get('/pet/$petId');
        final PetResDto petResDto = PetResDto.fromJson(response.data);

        String avatarUrl = await _loadAvatar(
          ctx: ctx,
          store: store,
          avatarName: petResDto.avatar ?? '',
        );

        store.dispatch(
          LoadPetSuccess(
            payload: Pet(
              petResDto: petResDto,
              avatarUrl: avatarUrl,
            ),
          ),
        );
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadPetFailure(payload: errorMsg));
      }
    };

Future<String> _loadAvatar({
  required String avatarName,
  required Store<RootState> store,
  required BuildContext ctx,
}) async {
  if (avatarName.isEmpty) {
    return '';
  }

  final List<ImageUrl> cachedImages = store.state.imageUrls.data!;

  ImageUrl? existingImage;

  try {
    existingImage = cachedImages.firstWhere((element) => element.name == avatarName);
  } catch (e) {}

  if (existingImage == null) {
    final String imageUrl = await FirebaseConstants.getAvatarUrl(
      avatarName: avatarName,
      ctx: ctx,
    );

    store.dispatch(LoadImageUrlsSuccess(payload: ImageUrl(name: avatarName, url: imageUrl)));
    return imageUrl;
  }

  return existingImage.url;
}
