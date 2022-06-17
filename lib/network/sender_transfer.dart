import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:transfer_file/data/code_transfer.dart';
import 'package:http/http.dart' as http;

class SenderTransfer {
  late String ip;

  ///Default port = 4040
  late int port;

  ///init, when mode = send
  ///null, when mode = standby || mode = receive
  late WebSocket sender;

  SenderTransfer({
    required this.ip,
    this.port = 4040,
  }) {}

  Future<void> init() async {
    sender = await WebSocket.connect('ws://$ip:$port/ws');
  }

  void close() {
    sender.close();
  }

  Future<void> sendFiles(List<CodeTransfer> data) async {
    for (final element in data) {
      final preData = http.MultipartFile.fromBytes('data', element.data!,
          filename: element.fileName,
          contentType: element.mimeType != null
              ? MediaType.parse(element.mimeType!)
              : null);

      sender.add(jsonEncode(element.toJson()));
      await sender.addStream(preData.finalize());
    }
  }
}
