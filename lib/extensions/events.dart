import 'package:flutter/cupertino.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/event_row.dart';

enum _EVENT_FILTER {
  PAST,
  TODAY,
  FUTURE,
  TOMORROW,
}

extension EventsExtenssion on List<EventResDto> {
  void sortByDate() {
    this.sort((prev, curr) =>
        DateTime.parse(prev.date).millisecondsSinceEpoch.compareTo(DateTime.parse(curr.date).millisecondsSinceEpoch));
  }

  List<EventResDto> getFutureEvents() {
    return _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.FUTURE);
  }

  List<EventResDto> getTomorrowEvents() {
    return _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.TOMORROW);
  }

  List<EventResDto> getTodayEvents() {
    return _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.TODAY);
  }

  List<EventResDto> getPastEvents() {
    return _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.PAST);
  }

  List<EventRow> getFutureEventRowList({required BuildContext ctx}) {
    final List<EventResDto> futureEvents = _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.FUTURE);
    return _getEventRowList(
      events: futureEvents,
      eventFilter: _EVENT_FILTER.FUTURE,
      ctx: ctx,
    );
  }

  List<EventRow> getTomorrowEventRowList({required BuildContext ctx}) {
    final List<EventResDto> tomorrowEvents = _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.TOMORROW);
    return _getEventRowList(
      events: tomorrowEvents,
      eventFilter: _EVENT_FILTER.TOMORROW,
      ctx: ctx,
    );
  }

  List<EventRow> getTodayEventRowList({required BuildContext ctx}) {
    final List<EventResDto> todayEvents = _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.TODAY);
    return _getEventRowList(
      events: todayEvents,
      eventFilter: _EVENT_FILTER.TODAY,
      ctx: ctx,
    );
  }

  List<EventRow> getPastEventRowList({required BuildContext ctx}) {
    final List<EventResDto> pastEvents = _getEventsByDate(events: this, eventFilter: _EVENT_FILTER.PAST);
    return _getEventRowList(
      events: pastEvents,
      eventFilter: _EVENT_FILTER.PAST,
      ctx: ctx,
    );
  }

  List<EventRow> _getEventRowList({
    required List<EventResDto> events,
    required BuildContext ctx,
    required _EVENT_FILTER eventFilter,
  }) {
    return events.asMap().entries.map((entry) {
      int idx = entry.key;
      EventResDto eventResDto = entry.value;

      String title = '';

      if (idx == 0) {
        switch (eventFilter) {
          case _EVENT_FILTER.PAST:
            title = L10n.of(ctx).past_events;
            break;
          case _EVENT_FILTER.TODAY:
            title = L10n.of(ctx).today_events;
            break;
          case _EVENT_FILTER.TOMORROW:
            title = L10n.of(ctx).tomorrow_events;
            break;
          case _EVENT_FILTER.FUTURE:
            title = L10n.of(ctx).upcoming_events;
            break;
        }
      }

      return EventRow.fromEventResDto(
        title: title,
        event: eventResDto,
      );
    }).toList();
  }

  List<EventResDto> _getEventsByDate({
    required _EVENT_FILTER eventFilter,
    required List<EventResDto> events,
  }) {
    final DateTime now = DateTime.now();
    return events.where((element) {
      final date = DateTime.parse(element.date).toLocal();
      final int daysDiff =
          DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
      switch (eventFilter) {
        case _EVENT_FILTER.PAST:
          return daysDiff < 0;
        case _EVENT_FILTER.TODAY:
          return daysDiff == 0;
        case _EVENT_FILTER.TOMORROW:
          return daysDiff == 1;
        case _EVENT_FILTER.FUTURE:
          return daysDiff > 0;
        default:
          return true;
      }
    }).toList();
  }
}
