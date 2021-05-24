import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';

import 'actions.dart';

AppState<PetResDto> petReducer(
    AppState<PetResDto> state, action) {
  if (action is LoadPet) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadPetSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadPetFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearPetState) {
    return AppState();
  }
  return state;
}
