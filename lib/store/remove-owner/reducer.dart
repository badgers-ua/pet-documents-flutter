import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

removeOwnerReducer(state, action) {
  if (action is LoadRemoveOwner) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadRemoveOwnerSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadRemoveOwnerFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearRemoveOwnerState) {
    return AppState();
  }
  return state;
}
