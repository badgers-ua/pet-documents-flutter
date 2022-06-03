import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/image_url.dart';
import 'package:pdoc/store/image-urls/actions.dart';

AppState<List<ImageUrl>> imageUrlsReducer(AppState<List<ImageUrl>> state, action) {
  if (action is LoadImageUrlsSuccess) {
    final List<ImageUrl> updatedData = [...(state.data ?? [])];

    final bool imageExists = updatedData.contains((element) => element.name == action.payload.name);

    if (!imageExists) {
      updatedData.add(action.payload);
    }

    return AppState(
      isLoading: false,
      data: updatedData,
      errorMessage: '',
    );
  }
  if (action is LoadImageUrlsFailure) {
    return AppState(
      isLoading: false,
      data: state.data,
      errorMessage: action.payload,
    );
  }
  if (action is ClearImageUrlsState) {
    return AppState(data: []);
  }
  return state;
}
