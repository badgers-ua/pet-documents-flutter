import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/screens/pet_profile_screen.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pets/effects.dart';
import 'package:pdoc/widgets/event_card_widget.dart';
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
        store.dispatch(loadPetsThunk(ctx: context));
      },
      converter: (store) {
        final AppState<List<PetPreviewResDto>> petPreviewState =
            store.state.pets;
        return _HomeScreenViewModel(
          state: petPreviewState,
        );
      },
      builder: (context, _HomeScreenViewModel vm) {
        if (vm.state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final List<PetPreviewResDto> petPreviewList = vm.state.data!;

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
              itemCount: petPreviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return PetCardWidget(
                  pet: petPreviewList[index],
                  onTap: () {
                    handlePetCardPressed(ctx: context, petId: petPreviewList[index].id);
                  },
                );
              },
              padding: const EdgeInsets.all(4.0),
            ),
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
            EventCardWidget(),
            EventCardWidget(),
            EventCardWidget(),
          ],
        );
      },
    );
  }
}

class _HomeScreenViewModel {
  final AppState<List<PetPreviewResDto>> state;

  _HomeScreenViewModel({
    required this.state,
  });
}
