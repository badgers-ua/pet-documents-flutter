import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

editEventReducer(state, action) {
  if (action is LoadEditEvent) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadEditEventSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadEditEventFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearEditEventState) {
    return AppState();
  }
  return state;
}
