import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:transfer_file/data/request_model.dart';

class NetworkWifi {
  final info = NetworkInfo();

  String? wifiName;

  String? wifiBSSID;

  String? wifiIP;

  String? wifiIPv6;

  String? wifiSubmask;

  String? wifiBroadcast;

  String? wifiGateway;

  Future<void> init() async {
    wifiName = await info.getWifiName();
    wifiBSSID = await info.getWifiBSSID();
    wifiIP = await info.getWifiIP();
    wifiIPv6 = await info.getWifiIPv6();
    wifiSubmask = await info.getWifiSubmask();
    wifiBroadcast = await info.getWifiBroadcast();
    wifiGateway = await info.getWifiGatewayIP();
  }

  Stream<List<RequestModel>> scanNetwork({int port = 4040}) async* {
    final list = <RequestModel>[];
    if (wifiIP != null) {
      final subnet = wifiIP!.substring(0, wifiIP!.lastIndexOf('.'));
      for (var i = 1; i < 256; i++) {
        final checkingIP = '$subnet.$i';
        if (checkingIP != wifiIP) {
          try {
            final res = await http.get(
                Uri.parse(
                  'http://$checkingIP:$port/request',
                ),
                headers: {
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Charset': 'utf-8'
                }).timeout(const Duration(milliseconds: 500));
            yield list..add(RequestModel.fromJson(jsonDecode(res.body)));
          } catch (e) {
            continue;
          }
        }
      }
    }
  }
}
