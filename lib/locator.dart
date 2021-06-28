import 'package:get_it/get_it.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/services/crashlitycs_service.dart';
import 'package:pdoc/services/in-app-purchase_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  locator.registerLazySingleton<CrashlyticsService>(() => CrashlyticsService());
  locator.registerLazySingleton<InAppPurchaseService>(() => InAppPurchaseService());
}
