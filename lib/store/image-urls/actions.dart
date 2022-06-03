import 'package:pdoc/models/image_url.dart';

import '../index.dart';

class LoadImageUrlsSuccess extends AppAction {
  final ImageUrl payload;

  LoadImageUrlsSuccess({required this.payload});
}

class LoadImageUrlsFailure extends AppAction {
  final String payload;

  LoadImageUrlsFailure({required this.payload});
}

class ClearImageUrlsState extends AppAction {
}
