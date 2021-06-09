import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/screens/add_edit_event_screen.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/widgets/event_row_widget.dart';
import 'package:pdoc/extensions/events.dart';

import '../../../../constants.dart';

class PetEventsSLiverListScreen extends StatelessWidget {
  Widget renderEventsListWidget({
    required List<_EventRow> events,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final Widget row = Container(
            child: EventRowWidget(
              event: events[index],
              onTap: () => Navigator.of(context)
                  .pushNamed(AddEditEventScreen.routeName, arguments: AddEditEventScreenProps(event: events[index])),
            ),
          );

          final String title = events[index].title;

          return title.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: ThemeConstants.spacing(1.5),
                        bottom: ThemeConstants.spacing(1),
                        left: ThemeConstants.spacing(0.5),
                        right: ThemeConstants.spacing(0.5),
                      ),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    row,
                  ],
                )
              : row;
        },
        childCount: events.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _PetEventsSLiverListScreenViewModel>(
      onInit: (store) {
        store.dispatch(loadEventsThunk(ctx: context));
      },
      converter: (store) {
        final List<EventResDto> events =
            store.state.events.data!.where((element) => element.petId == store.state.pet.data!.id).toList();
        events.sortByDate();

        return _PetEventsSLiverListScreenViewModel(
          error: store.state.events.errorMessage.isNotEmpty || store.state.pet.errorMessage.isNotEmpty,
          isLoadingEvents: store.state.events.isLoading,
          isLoadingPet: store.state.pet.isLoading,
          pastEvents: events.getPastEvents().asMap().entries.map((entry) {
            int idx = entry.key;
            EventResDto eventResDto = entry.value;
            return _EventRow.fromEventResDto(
              title: idx == 0 ? L10n.of(context).past_events : '',
              event: eventResDto,
            );
          }).toList(),
          futureEvents: events.getFutureEvents().asMap().entries.map((entry) {
            int idx = entry.key;
            EventResDto eventResDto = entry.value;
            return _EventRow.fromEventResDto(
              title: idx == 0 ? L10n.of(context).upcoming_events : '',
              event: eventResDto,
            );
          }).toList(),
          pet: store.state.pet.data,
        );
      },
      builder: (context, _PetEventsSLiverListScreenViewModel vm) {
        if (vm.isLoadingEvents || vm.isLoadingPet) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (vm.error) {
          return SliverFillRemaining(
            child: Center(
              child: Text(L10n.of(context).something_went_wrong),
            ),
          );
        }

        if ([...vm.futureEvents, ...vm.pastEvents].isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(L10n.of(context).no_events_text),
            ),
          );
        }

        return renderEventsListWidget(events: [...vm.futureEvents, ...vm.pastEvents]);
      },
    );
  }
}

class _EventRow extends EventResDto {
  final String title;

  _EventRow({
    required this.title,
    isNotification,
    petId,
    date,
    id,
    type,
    description,
  }) : super(
          isNotification: isNotification,
          petId: petId,
          date: date,
          id: id,
          type: type,
          description: description,
        );

  static _EventRow fromEventResDto({
    required EventResDto event,
    required String title,
  }) {
    return _EventRow(
      id: event.id,
      type: event.type,
      description: event.description,
      date: event.date,
      petId: event.petId,
      isNotification: event.isNotification,
      title: title,
    );
  }
}

class _PetEventsSLiverListScreenViewModel {
  final bool isLoadingEvents;
  final bool isLoadingPet;
  final bool error;
  final PetResDto? pet;
  final List<_EventRow> pastEvents;
  final List<_EventRow> futureEvents;

  _PetEventsSLiverListScreenViewModel({
    required this.isLoadingEvents,
    required this.isLoadingPet,
    required this.error,
    required this.pet,
    required this.pastEvents,
    required this.futureEvents,
  });
}
