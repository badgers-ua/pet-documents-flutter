import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_profile_screen.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:pdoc/widgets/event_row_widget.dart';
import 'package:pdoc/widgets/pet_card_widget.dart';

class HomeScreen extends StatelessWidget {
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

        events.sort((prev, curr) =>
            DateTime
                .parse(prev.date)
                .millisecondsSinceEpoch
                .compareTo(DateTime
                .parse(curr.date)
                .millisecondsSinceEpoch));

        return _HomeScreenViewModel(
          pets: store.state.pets.data!,
          futureEvents: events.length > 2 ? events.sublist(0, 3) : events,
          isLoadingPets: store.state.pets.isLoading,
          isLoadingEvents: store.state.events.isLoading,
        );
      },
      builder: (context, _HomeScreenViewModel vm) {
        if (vm.isLoadingPets || vm.isLoadingEvents) {
          return Center(child: CircularProgressIndicator());
        }

        if (vm.pets.isEmpty) {
          return Center(child: Text(L10n
              .of(context)
              .no_pets_text));
        }

        return ListView(
          padding: EdgeInsets.all(ThemeConstants.spacing(1)),
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: ThemeConstants.spacing(0.5),
                left: ThemeConstants.spacing(0.5),
              ),
              child: Text(
                L10n
                    .of(context)
                    .home_screen_pets_title_text,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5,
              ),
            ),
            GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
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
                    handlePetCardPressed(
                        ctx: context, petId: vm.pets[index].id);
                  },
                );
              },
              padding: const EdgeInsets.all(4.0),
            ),
            if (vm.futureEvents.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(ThemeConstants.spacing(0.5)),
                child: Text(
                  L10n
                      .of(context)
                      .home_screen_events_title_text,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
              Column(
                children: vm.futureEvents
                    .map((e) =>
                    Card(
                        child: EventRowWidget(
                          event: e,
                          prefix: '${vm.pets
                            .firstWhere((element) => element.id == e.petId)
                            .name}: ',
                        )))
                    .toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HomeScreenViewModel {
  final List<PetPreviewResDto> pets;
  final List<EventResDto> futureEvents;
  final bool isLoadingPets;
  final bool isLoadingEvents;

  _HomeScreenViewModel({
    required this.pets,
    required this.futureEvents,
    required this.isLoadingPets,
    required this.isLoadingEvents,
  });
}
