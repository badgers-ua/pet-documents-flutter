import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  Future<void> setUserIdentifier({required String userId}) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  Future<void> removeUserIdentifier() async {
    await FirebaseCrashlytics.instance.setUserIdentifier('null');
  }

  void testCrash() {
    FirebaseCrashlytics.instance.crash();
  }
}
