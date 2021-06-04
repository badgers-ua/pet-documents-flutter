import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/breeds_state.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/add-owner/reducer.dart';
import 'package:pdoc/store/breeds/reducer.dart';
import 'package:pdoc/store/create-event/reducer.dart';
import 'package:pdoc/store/delete-event/reducer.dart';
import 'package:pdoc/store/delete-pet/reducers.dart';
import 'package:pdoc/store/edit-event/reducer.dart';
import 'package:pdoc/store/edit-pet/reducers.dart';
import 'package:pdoc/store/events/reducer.dart';
import 'package:pdoc/store/pet/reducers.dart';
import 'package:pdoc/store/pets/reducers.dart';
import 'package:pdoc/store/remove-owner/reducer.dart';
import 'package:pdoc/store/sign-up/reducers.dart';
import 'package:pdoc/store/user/reducers.dart';

import 'add-pet/reducers.dart';
import 'auth/reducers.dart';
import 'device-token/reducers.dart';

class AppAction {
  AppAction();
  String toString() {
    return '$runtimeType';
  }
}

class RootState {
  final AuthState auth;
  final AppState signUp;
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
  final AppState createEvent;
  final AppState editEvent;
  final AppState deleteEvent;
  final AppState<List<EventResDto>> events;

  RootState({
    required this.auth,
    required this.signUp,
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
    required this.createEvent,
    required this.editEvent,
    required this.deleteEvent,
    required this.events,
  });

  RootState.initialState()
      : auth = AuthState(isLoadingAccessToken: true),
        signUp = AppState(),
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
        createEvent = AppState(),
        editEvent = AppState(),
        deleteEvent = AppState(),
        events = AppState(data: []),
        deletePet = AppState();
}

RootState appReducer(RootState state, action) {
  return RootState(
    auth: authReducer(state.auth, action),
    signUp: signUpReducer(state.signUp, action),
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
    createEvent: createEventReducer(state.createEvent, action),
    editEvent: editEventReducer(state.editEvent, action),
    deleteEvent: deleteEventReducer(state.deleteEvent, action),
    events: eventReducer(state.events, action),
  );
}
