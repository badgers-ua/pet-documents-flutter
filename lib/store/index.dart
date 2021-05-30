import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/breeds_state.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/add-owner/reducer.dart';
import 'package:pdoc/store/breeds/reducer.dart';
import 'package:pdoc/store/delete-pet/reducers.dart';
import 'package:pdoc/store/edit-pet/reducers.dart';
import 'package:pdoc/store/pet/reducers.dart';
import 'package:pdoc/store/pets/reducers.dart';
import 'package:pdoc/store/remove-owner/reducer.dart';
import 'package:pdoc/store/user/reducers.dart';

import 'add-pet/reducers.dart';
import 'auth/reducers.dart';
import 'device_token/reducers.dart';

class AppAction {
  AppAction();
  String toString() {
    return '$runtimeType';
  }
}

class RootState {
  final AuthState auth;
  final AppState<DeviceToken> deviceToken;
  final AppState<List<PetPreviewResDto>> pets;
  final AppState<PetResDto> pet;
  final AppState<UserResDto> user;
  final BreedsState breeds;
  final AppState addPet;
  final AppState editPet;
  final AppState addOwner;
  final AppState removeOwner;
  final AppState deletePet;

  RootState({
    required this.auth,
    required this.deviceToken,
    required this.pets,
    required this.pet,
    required this.user,
    required this.breeds,
    required this.addPet,
    required this.editPet,
    required this.addOwner,
    required this.removeOwner,
    required this.deletePet,
  });

  RootState.initialState()
      : auth = AuthState(isLoadingAccessToken: true),
        deviceToken = AppState(),
        pets = AppState(data: []),
        pet = AppState(),
        user = AppState(),
        breeds = BreedsState(
          data: {},
          selectedSpecies: null,
        ),
        addPet = AppState(),
        editPet = AppState(),
        addOwner = AppState(),
        removeOwner = AppState(),
        deletePet = AppState();
}

RootState appReducer(RootState state, action) {
  return RootState(
    auth: authReducer(state.auth, action),
    deviceToken: deviceTokenReducer(state.deviceToken, action),
    pets: petsReducer(state.pets, action),
    pet: petReducer(state.pet, action),
    user: userReducer(state.user, action),
    breeds: breedsReducer(state.breeds, action),
    addPet: addPetReducer(state.addPet, action),
    editPet: editPetReducer(state.editPet, action),
    addOwner: addOwnerReducer(state.addOwner, action),
    removeOwner: removeOwnerReducer(state.removeOwner, action),
    deletePet: deletePetReducer(state.deletePet, action),
  );
}
