import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';

import 'actions.dart';

AppState<List<PetPreviewResDto>> petsReducer(
    AppState<List<PetPreviewResDto>> state, action) {
  if (action is LoadPets) {
    return AppState(
      isLoading: true,
      data: [],
      errorMessage: '',
    );
  }
  if (action is LoadPetsSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadPetsFailure) {
    return AppState(
      isLoading: false,
      data: [],
      errorMessage: action.payload,
    );
  }
  if (action is ClearPetsState) {
    return AppState(data: []);
  }
  return state;
}
