import 'package:pdoc/models/device_token.dart';
import '../index.dart';

class LoadDeviceTokenSuccess extends AppAction {
  final DeviceToken payload;

  LoadDeviceTokenSuccess({required this.payload});
}