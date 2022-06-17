import 'dart:io';

import 'package:album_image/album_image.dart';
import 'package:flutter/material.dart';
import 'package:transfer_file/data/code_transfer.dart';
import 'package:transfer_file/di/app_injector.dart';
import 'package:transfer_file/network/sender_transfer.dart';

class SendScreen extends StatefulWidget {
  final SenderTransfer sender;

  const SendScreen({Key? key, required this.sender}) : super(key: key);

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  List<AssetEntity> sendData = [];

  late SenderTransfer _senderTransfer;

  @override
  void initState() {
    super.initState();
    _senderTransfer = widget.sender;
  }

  @override
  void dispose() {
    _senderTransfer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Send'),
      ),
      body: AlbumImagePicker(
        onSelected: onSelected,
        selected: sendData,
        maxSelection: 10,
        appBarColor: Colors.blue,
        closeWidget: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSend,
        tooltip: 'Increment',
        child: const Icon(Icons.send_to_mobile_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> onSend() async {
    final files = <CodeTransfer>[];
    for (final element in sendData) {
      final fileData = await element.originBytes;
      final mimeType = await element.mimeTypeAsync;
      if (fileData != null) {
        files.add(CodeTransfer(
          id: element.id,
            mimeType: mimeType, data: fileData, fileName: element.title));
      }
    }
    await _senderTransfer.sendFiles(files);
    // Dart client
  }

  void onSelected(List<AssetEntity> images) {
    sendData = images;
  }
}
