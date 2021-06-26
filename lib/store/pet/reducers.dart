import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/pet_state.dart';

import 'actions.dart';

AppState<Pet> petReducer(AppState<Pet> state, action) {
  if (action is LoadPet) {
    return AppState(
      isLoading: true,
      data: Pet(avatarUrl: '', petResDto: null),
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
      data: Pet(avatarUrl: '', petResDto: null),
      errorMessage: action.payload,
    );
  }
  if (action is ClearPetState) {
    return AppState(
      data: Pet(avatarUrl: '', petResDto: null),
    );
  }
  return state;
}
