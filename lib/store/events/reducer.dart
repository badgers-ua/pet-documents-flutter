import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

import 'actions.dart';

AppState<List<EventResDto>> eventReducer(AppState<List<EventResDto>> state, action) {
  if (action is LoadEvents) {
    return AppState(
      isLoading: true,
      data: [],
      errorMessage: '',
    );
  }
  if (action is LoadEventsSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadEventsFailure) {
    return AppState(
      isLoading: false,
      data: [],
      errorMessage: action.payload,
    );
  }
  if (action is ClearEventsState) {
    return AppState(data: []);
  }
  return state;
}
