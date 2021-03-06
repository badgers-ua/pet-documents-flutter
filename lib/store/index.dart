import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/auth.dart';
import 'package:pdoc/models/breeds_state.dart';
import 'package:pdoc/models/device_token.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/models/image_url.dart';
import 'package:pdoc/models/pet_state.dart';
import 'package:pdoc/store/add-owner/reducer.dart';
import 'package:pdoc/store/breeds/reducer.dart';
import 'package:pdoc/store/create-event/reducer.dart';
import 'package:pdoc/store/delete-event/reducer.dart';
import 'package:pdoc/store/delete-pet/reducers.dart';
import 'package:pdoc/store/edit-event/reducer.dart';
import 'package:pdoc/store/edit-pet/reducers.dart';
import 'package:pdoc/store/events/reducer.dart';
import 'package:pdoc/store/image-urls/reducer.dart';
import 'package:pdoc/store/pet/reducers.dart';
import 'package:pdoc/store/pets/reducers.dart';
import 'package:pdoc/store/remove-owner/reducer.dart';
import 'package:pdoc/store/sign-out/reducers.dart';
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
  final AppState signOut;
  final AppState<DeviceToken> deviceToken;
  final AppState<List<PetPreviewResDto>> pets;
  final AppState<Pet> pet;
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
  final AppState<List<ImageUrl>> imageUrls;

  RootState({
    required this.auth,
    required this.signOut,
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
    required this.imageUrls,
  });

  RootState.initialState()
      : auth = AuthState(isLoadingAccessToken: true),
        signOut = AppState(),
        deviceToken = AppState(),
        pets = AppState(data: []),
        pet = AppState(
            data: Pet(
          avatarUrl: '',
          petResDto: null,
        )),
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
        imageUrls = AppState(data: []),
        deletePet = AppState();
}

RootState appReducer(RootState state, action) {
  return RootState(
    auth: authReducer(state.auth, action),
    signOut: signOutReducer(state.signOut, action),
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
    imageUrls: imageUrlsReducer(state.imageUrls, action),
    events: eventReducer(state.events, action),
  );
}
