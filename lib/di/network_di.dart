import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:transfer_file/app/device_info.dart';
import 'package:transfer_file/network/network_wifi.dart';
import 'package:transfer_file/network/receiver_transfer.dart';

class NetWorkDI {
  NetWorkDI._();

  static Future<void> init(GetIt injector) async {
    final network = NetworkWifi();
    await network.init();

    injector
      ..registerSingleton<NetworkWifi>(network)
      ..registerSingleton<ReceiverTransfer>(ReceiverTransfer(
          ip: network.wifiIP!,
          deviceName: injector<DeviceInfo>().deviceName ?? ''));
  }
}
