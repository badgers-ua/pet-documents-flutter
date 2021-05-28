import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';

import 'actions.dart';

AppState<Map<SPECIES, List<StaticResDto>>> breedsReducer(
    AppState<Map<SPECIES, List<StaticResDto>>> state, action) {
  if (action is LoadBreeds) {
    return AppState(
      isLoading: true,
      data: state.data,
      errorMessage: '',
    );
  }
  if (action is LoadBreedsSuccess) {
    final updatedData = state.data!;
    updatedData.addAll(action.payload);

    return AppState(
      isLoading: false,
      data: updatedData,
      errorMessage: '',
    );
  }
  if (action is LoadBreedsFailure) {
    return AppState(
      isLoading: false,
      data: state.data,
      errorMessage: action.payload,
    );
  }
  if (action is ClearBreedsState) {
    return AppState();
  }
  return state;
}
