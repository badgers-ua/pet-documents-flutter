import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

deletePetReducer(state, action) {
  if (action is LoadDeletePet) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadDeletePetSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadDeletePetFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearDeletePetState) {
    return AppState();
  }
  return state;
}
