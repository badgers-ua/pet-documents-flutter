import 'dto/response/event_res_dto.dart';

class EventRow extends EventResDto {
  final String title;

  EventRow({
    required this.title,
    // TODO: [Feature]: Push notifications
    // isNotification,
    petId,
    date,
    id,
    type,
    description,
  }) : super(
          // TODO: [Feature]: Push notifications
          // isNotification: isNotification,
          petId: petId,
          date: date,
          id: id,
          type: type,
          description: description,
        );

  static EventRow fromEventResDto({
    required EventResDto event,
    required String title,
  }) {
    return EventRow(
      id: event.id,
      type: event.type,
      description: event.description,
      date: event.date,
      petId: event.petId,
      // TODO: [Feature]: Push notifications
      // isNotification: event.isNotification,
      title: title,
    );
  }
}
