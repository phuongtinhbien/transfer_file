import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:transfer_file/data/code_transfer.dart';
import 'package:transfer_file/di/app_injector.dart';
import 'package:transfer_file/network/receiver_transfer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  List<CodeTransfer> receivedData = [];

  late ReceiverTransfer _receiverTransfer;

  @override
  void initState() {
    super.initState();
    _receiverTransfer = AppInjector.injector<ReceiverTransfer>()
      ..onData = handleMsg;
  }

  @override
  void dispose() {
    _receiverTransfer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Received'),
      ),
      body: SizedBox.expand(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
          itemBuilder: (_, index) {
            final item = receivedData[index];
            if (item.data != null) {
              if (item.mimeType!.startsWith('image')) {
                return Image.memory(
                  item.data!,
                  fit: BoxFit.cover,
                );
              } else if (item.mimeType!.startsWith('video')) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(item.mimeType!),
                );
              }
            }
            return Container(
              child: SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            );
          },
          itemCount: receivedData.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        tooltip: 'Increment',
        child: const Icon(Icons.save_alt),
      ),
    );
  }

  void handleMsg(HttpRequest req, event) {
    print(event.runtimeType);
    if (event is String) {
      final json = jsonDecode(event);
      print(json);
      receivedData.add(CodeTransfer.fromJson(json));
    } else {
      receivedData.last.data ??= event;
    }
    setState(() {});
  }

  Future<void> saveData() async {
    for (final item in receivedData) {
      if (item.mimeType!.startsWith('image')) {
        await PhotoManager.editor.saveImage(
          item.data!,
          title: item.fileName ?? '',
        );
      } else if (item.mimeType!.startsWith('video')) {
        final path = (await getApplicationDocumentsDirectory()).path;

        File('$path/${item.fileName!}').writeAsBytes(item.data!).then((file) {
          PhotoManager.editor.saveVideo(file, title: item.fileName ?? '');
        });
      } else {}
    }
  }
}
