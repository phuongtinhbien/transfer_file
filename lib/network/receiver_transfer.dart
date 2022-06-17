import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:transfer_file/data/request_model.dart';

class ReceiverTransfer {
  late String ip;

  ///Default port = 4040
  late int port;

  ///init, when mode = receive
  ///null, when mode = standby || mode = send
  late HttpServer receiver;

  Function(HttpRequest request, dynamic)? onData;

  Function? onError;

  VoidCallback? onDone;

  Function(dynamic)? onRequestConnection;
  VoidCallback? onConnected;

  bool? cancelOnError;

  String deviceName;

  ReceiverTransfer({
    required this.ip,
    required this.deviceName,
    this.onData,
    this.port = 4040,
    this.onDone,
    this.onError,
    this.onRequestConnection,
    this.cancelOnError,
  }) {
    init();
  }

  Future<void> init() async {
    receiver = await HttpServer.bind(ip, port);
    receiver.listen((req) async {
      if (req.uri.path == '/ws') {
        final socket = await WebSocketTransformer.upgrade(req);
        socket.listen((event) {
          onData?.call(req, event);
        }, onDone: () {
          onDone?.call();
          socket.close();
        }, onError: onError, cancelOnError: cancelOnError);
      } else if (req.uri.path == '/request') {
        req.response
          ..write(jsonEncode(
              RequestModel(ipAddress: ip, port: port, deviceName: deviceName)
                  .toJson()))
          ..close();
      }
    });
  }

  void close() {
    receiver.close();
  }
}
