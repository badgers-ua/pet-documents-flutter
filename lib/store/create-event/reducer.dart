import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

createEventReducer(state, action) {
  if (action is LoadCreateEvent) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadCreateEventSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadCreateEventFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearCreateEventState) {
    return AppState();
  }
  return state;
}
