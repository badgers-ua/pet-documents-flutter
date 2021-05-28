import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

addEditPetReducer(state, action) {
  if (action is LoadAddEditPet) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddEditPetSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddEditPetFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearAddEditPetState) {
    return AppState();
  }
  return state;
}
