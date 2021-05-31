import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/widgets/event_row_widget.dart';
import 'package:pdoc/extensions/events.dart';

class PetEventsSLiverListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _PetEventsSLiverListScreenViewModel>(
      onInit: (store) {
        store.dispatch(loadEventsThunk(ctx: context));
      },
      converter: (store) {
        final List<EventResDto> events = store.state.events.data!.where((element) => element.petId == store.state.pet.data!.id).toList();
        events.sortByDate();

        return _PetEventsSLiverListScreenViewModel(
          isLoadingEvents: store.state.events.isLoading,
          events: events,
        );
      },
      builder: (context, _PetEventsSLiverListScreenViewModel vm) {
        if (vm.isLoadingEvents) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (vm.events.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(L10n.of(context).no_events_text),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: EventRowWidget(
                  event: vm.events[index],
                ),
              );
            },
            childCount: vm.events.length,
          ),
        );
      },
    );
  }
}

class _PetEventsSLiverListScreenViewModel {
  final bool isLoadingEvents;
  final List<EventResDto> events;

  _PetEventsSLiverListScreenViewModel({
    required this.isLoadingEvents,
    required this.events,
  });
}
