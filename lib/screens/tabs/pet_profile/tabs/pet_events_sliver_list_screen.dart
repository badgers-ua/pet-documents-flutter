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

class PetEventsSLiverListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _PetEventsSLiverListScreenViewModel>(
      onInit: (store) {
        store.dispatch(loadEventsThunk(ctx: context));
      },
      converter: (store) {
        final List<EventResDto> events = store.state.events.data!
            .where((element) => element.petId == store.state.pet.data!.id)
            .toList();
        // TODO: Future events first
        // TODO: Differentiate using list titles past and future events
        events.sortByDate();

        return _PetEventsSLiverListScreenViewModel(
          error: store.state.events.errorMessage.isNotEmpty || store.state.pet.errorMessage.isNotEmpty,
          isLoadingEvents: store.state.events.isLoading,
          isLoadingPet: store.state.pet.isLoading,
          events: events,
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
                  onTap: () => Navigator.of(context).pushNamed(
                      AddEditEventScreen.routeName,
                      arguments: AddEditEventScreenProps(event: vm.events[index])),
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
  final bool isLoadingPet;
  final bool error;
  final PetResDto? pet;
  final List<EventResDto> events;

  _PetEventsSLiverListScreenViewModel({
    required this.isLoadingEvents,
    required this.isLoadingPet,
    required this.error,
    required this.events,
    required this.pet,
  });
}
