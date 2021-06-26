import 'package:get_it/get_it.dart';
import 'package:pdoc/services/analytics_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
}
