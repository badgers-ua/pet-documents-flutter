import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

addOwnerReducer(state, action) {
  if (action is LoadAddOwner) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddOwnerSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadAddOwnerFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearAddOwnerState) {
    return AppState();
  }
  return state;
}
