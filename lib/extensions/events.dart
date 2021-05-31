import 'package:pdoc/models/dto/response/event_res_dto.dart';

extension Sort on List<EventResDto> {
  void sortByDate() {
    this.sort((prev, curr) => DateTime.parse(prev.date)
        .millisecondsSinceEpoch
        .compareTo(DateTime.parse(curr.date).millisecondsSinceEpoch));
  }
}