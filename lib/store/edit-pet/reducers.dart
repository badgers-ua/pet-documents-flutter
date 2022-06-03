import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

editPetReducer(state, action) {
  if (action is LoadEditPet) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadEditPetSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadEditPetFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearEditPetState) {
    return AppState();
  }
  return state;
}
