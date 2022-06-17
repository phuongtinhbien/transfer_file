import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  late final deviceInfo;

  Future<void> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfo = await deviceInfoPlugin.deviceInfo;
  }

  /// Returns device information for the current platform.
  String? get deviceName {
    if (Platform.isAndroid) {
      return (deviceInfo as AndroidDeviceInfo).host;
    } else if (Platform.isIOS) {
      return (deviceInfo as IosDeviceInfo).name;
    }

    throw UnsupportedError('Unsupported platform');
  }
}
