import 'package:pdoc/models/breeds_state.dart';

import 'actions.dart';

BreedsState breedsReducer(BreedsState state, action) {
  if (action is SetSelectedSpecies) {
    return BreedsState(
      isLoading: false,
      data: state.data,
      errorMessage: '',
      selectedSpecies: action.payload,
    );
  }
  if (action is LoadBreeds) {
    return BreedsState(
      isLoading: true,
      data: state.data,
      errorMessage: '',
      selectedSpecies: state.selectedSpecies,
    );
  }
  if (action is LoadBreedsSuccess) {
    final updatedData = state.data!;
    updatedData.addAll(action.payload);

    return BreedsState(
      isLoading: false,
      data: updatedData,
      errorMessage: '',
      selectedSpecies: state.selectedSpecies,
    );
  }
  if (action is LoadBreedsFailure) {
    return BreedsState(
      isLoading: false,
      data: state.data,
      errorMessage: action.payload,
      selectedSpecies: state.selectedSpecies,
    );
  }
  if (action is ClearBreedsState) {
    return BreedsState(
      data: {},
      selectedSpecies: null,
    );
  }
  return state;
}
