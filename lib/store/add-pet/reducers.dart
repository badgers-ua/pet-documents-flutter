import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

addPetReducer(state, action) {
  if (action is LoadAddPet) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddPetSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddPetFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearAddPetState) {
    return AppState();
  }
  return state;
}
