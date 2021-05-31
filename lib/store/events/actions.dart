import 'package:pdoc/models/dto/response/event_res_dto.dart';

import '../index.dart';

class LoadEvents extends AppAction {}

class LoadEventsSuccess extends AppAction {
  final List<EventResDto> payload;

  LoadEventsSuccess({required this.payload});
}

class LoadEventsFailure extends AppAction {
  final String payload;

  LoadEventsFailure({required this.payload});
}

class ClearEventsState extends AppAction {
}
