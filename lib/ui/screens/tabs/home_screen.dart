import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/event_row.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:pdoc/extensions/events.dart';
import 'package:pdoc/ui/screens/tabs/pet_profile/pet_profile_screen.dart';
import 'package:pdoc/ui/widgets/event_row_widget.dart';
import 'package:pdoc/ui/widgets/pet_card_widget.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/tab-home';

  void handlePetCardPressed({
    required BuildContext ctx,
    required String petId,
  }) {
    Navigator.of(ctx).pushNamed(
      PetProfileScreen.routeName,
      arguments: PetProfileScreenProps(
        petId: petId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _HomeScreenViewModel>(
      onInit: (store) {
        if (store.state.pets.data!.isNotEmpty) {
          return;
        }
        store.dispatch(loadPetsThunk(ctx: context));
        if (store.state.events.data!.isNotEmpty) {
          return;
        }
        store.dispatch(loadEventsThunk(ctx: context));
      },
      converter: (store) {
        final List<EventResDto> events = store.state.events.data!;
        events.sortByDate();

        return _HomeScreenViewModel(
          pets: store.state.pets.data!,
          error: store.state.pets.errorMessage.isNotEmpty || store.state.events.errorMessage.isNotEmpty,
          tomorrowEvents: events.getTomorrowEventRowList(ctx: context),
          todayEvents: events.getTodayEventRowList(ctx: context),
          isLoadingPets: store.state.pets.isLoading,
          isLoadingEvents: store.state.events.isLoading,
        );
      },
      builder: (context, _HomeScreenViewModel vm) {
        if (vm.isLoadingPets || vm.isLoadingEvents) {
          return Center(child: CircularProgressIndicator());
        }

        if (vm.error) {
          return Center(
            child: Text(L10n.of(context).something_went_wrong),
          );
        }

        if (vm.pets.isEmpty) {
          return Center(child: Text(L10n.of(context).no_pets_text));
        }

        final List<EventRow> events = [...vm.todayEvents, ...vm.tomorrowEvents];

        return ListView(
          padding: EdgeInsets.all(ThemeConstants.spacing(1)),
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: ThemeConstants.spacing(0.5),
                left: ThemeConstants.spacing(0.5),
              ),
              child: Text(
                L10n.of(context).home_screen_pets_title_text,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: ThemeConstants.spacing(0.5),
                mainAxisSpacing: ThemeConstants.spacing(0.5),
              ),
              shrinkWrap: true,
              primary: false,
              itemCount: vm.pets.length,
              itemBuilder: (BuildContext context, int index) {
                return PetCardWidget(
                  pet: vm.pets[index],
                  onTap: () {
                    handlePetCardPressed(ctx: context, petId: vm.pets[index].id);
                  },
                );
              },
              padding: const EdgeInsets.all(4.0),
            ),
            if (events.isNotEmpty)
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  final bool isTodayEvent = index < vm.todayEvents.length;
                  final EventRow eventRow = events[index];
                  final Widget eventRowWidget = EventRowWidget(
                    event: eventRow,
                    prefix: '(${vm.pets.firstWhere((element) => element.id == eventRow.petId).name}): ',
                  );
                  return Container(
                    key: ValueKey(events[index].id),
                    child: eventRow.title.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ThemeConstants.spacing(0.5)),
                                child: Text(
                                  isTodayEvent ? L10n.of(context).today_events : L10n.of(context).tomorrow_events,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              eventRowWidget,
                            ],
                          )
                        : eventRowWidget,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _HomeScreenViewModel {
  final List<PetPreviewResDto> pets;
  final List<EventRow> todayEvents;
  final List<EventRow> tomorrowEvents;
  final bool isLoadingPets;
  final bool error;
  final bool isLoadingEvents;

  _HomeScreenViewModel({
    required this.pets,
    required this.todayEvents,
    required this.tomorrowEvents,
    required this.isLoadingPets,
    required this.error,
    required this.isLoadingEvents,
  });
}
