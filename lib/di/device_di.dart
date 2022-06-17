import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:transfer_file/app/device_info.dart';

class DeviceDI {
  DeviceDI._();

  static Future<void> init(GetIt injector) async {
    final deviceInfo = DeviceInfo();
    await deviceInfo.init();
    injector.registerSingleton<DeviceInfo>(deviceInfo);
  }
}
