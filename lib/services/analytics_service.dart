import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:pdoc/constants.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties({required String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future logFirebaseGoogleLogin() async {
    await _analytics.logLogin(loginMethod: AnalyticsConstants.firebaseGoogleLogin);
  }

  Future logGoogleLogin() async {
    await _analytics.logLogin(loginMethod: AnalyticsConstants.googleLogin);
  }

  Future logSilentToken() async {
    await _analytics.logEvent(name: AnalyticsConstants.silentToken);
  }

  Future logLogout() async {
    await _analytics.logEvent(name: AnalyticsConstants.logOut);
  }

  Future logError({required String errorMsg}) async {
    await _analytics.logEvent(
      name: AnalyticsConstants.error,
      parameters: {
        AnalyticsConstants.errorMessage: errorMsg,
      },
    );
  }

  Future logBreedsLoaded({required String species}) async {
    await _analytics.logEvent(
      name: AnalyticsConstants.breedsLoaded,
      parameters: {
        AnalyticsConstants.species: species,
      },
    );
  }

  Future logEventCreated() async {
    await _analytics.logEvent(name: AnalyticsConstants.eventCreated);
  }

  Future logEventDeleted() async {
    await _analytics.logEvent(name: AnalyticsConstants.eventDeleted);
  }

  Future logEventEdited() async {
    await _analytics.logEvent(name: AnalyticsConstants.eventEdited);
  }

  Future logEventsLoaded() async {
    await _analytics.logEvent(name: AnalyticsConstants.eventsLoaded);
  }

  Future logOwnedAdded() async {
    await _analytics.logEvent(name: AnalyticsConstants.ownerAdded);
  }

  Future logOwnedRemoved() async {
    await _analytics.logEvent(name: AnalyticsConstants.ownerRemoved);
  }

  Future logPetCreated({required bool hasAvatar}) async {
    await _analytics.logEvent(
      name: AnalyticsConstants.petCreated,
      parameters: {
        AnalyticsConstants.hasAvatar: hasAvatar,
      },
    );
  }

  Future logPetLoaded() async {
    await _analytics.logEvent(name: AnalyticsConstants.petLoaded);
  }

  Future logPetsLoaded() async {
    await _analytics.logEvent(name: AnalyticsConstants.petsLoaded);
  }

  Future logPetEdited({required bool hasAvatar}) async {
    await _analytics.logEvent(
      name: AnalyticsConstants.petEdited,
      parameters: {
        AnalyticsConstants.hasAvatar: hasAvatar,
      },
    );
  }

  Future logPetDeleted() async {
    await _analytics.logEvent(name: AnalyticsConstants.petDeleted);
  }
}
