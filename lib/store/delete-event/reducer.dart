import 'package:pdoc/models/app_state.dart';

import 'actions.dart';

deleteEventReducer(state, action) {
  if (action is LoadDeleteEvent) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadDeleteEventSuccess) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadDeleteEventFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearDeleteEventState) {
    return AppState();
  }
  return state;
}
