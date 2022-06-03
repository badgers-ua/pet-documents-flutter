import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/user/actions.dart';

AppState<UserResDto> userReducer(AppState<UserResDto> state, action) {
  if (action is LoadUser) {
    return AppState(
      isLoading: true,
      data: null,
      errorMessage: '',
    );
  }
  if (action is LoadUserSuccess) {
    return AppState(
      isLoading: false,
      data: action.payload,
      errorMessage: '',
    );
  }
  if (action is LoadUserFailure) {
    return AppState(
      isLoading: false,
      data: null,
      errorMessage: action.payload,
    );
  }
  if (action is ClearUserState) {
    return AppState();
  }

  return state;
}
