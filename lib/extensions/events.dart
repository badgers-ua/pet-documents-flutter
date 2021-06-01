import 'package:pdoc/models/dto/response/event_res_dto.dart';

extension EventsExtenssion on List<EventResDto> {
  void sortByDate() {
    this.sort((prev, curr) => DateTime.parse(prev.date)
        .millisecondsSinceEpoch
        .compareTo(DateTime.parse(curr.date).millisecondsSinceEpoch));
  }

  List<EventResDto> getFutureEvents() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return this.where((element) => DateTime.parse(element.date).millisecondsSinceEpoch > now).toList();
  }
}