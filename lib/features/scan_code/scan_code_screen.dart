import 'dart:convert';
import 'dart:io';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transfer_file/data/request_model.dart';
import 'package:transfer_file/di/app_injector.dart';
import 'package:transfer_file/features/scan_code/scan_code_bloc.dart';
import 'package:transfer_file/features/send_screen/send_screen.dart';
import 'package:transfer_file/network/network_wifi.dart';
import 'package:transfer_file/network/receiver_transfer.dart';
import 'package:transfer_file/network/sender_transfer.dart';

class ScanCodeScreen extends StatefulWidget {
  const ScanCodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen>
    with TickerProviderStateMixin {
  final ScanCodeBloc _bloc = AppInjector.injector<ScanCodeBloc>();

  late ReceiverTransfer _receiverTransfer;

  @override
  void initState() {
    super.initState();
    _receiverTransfer = AppInjector.injector<ReceiverTransfer>()
      ..onData = handleMsg;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Devices in Network'),
      ),
      body: Container(
        width: size.width,
        child: StreamBuilder<List<RequestModel>>(
            stream: AppInjector.injector<NetworkWifi>().scanNetwork(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2))
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.deviceName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  item.ipAddress,
                                  style:const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () => onConnectTap(item),
                              child: Text('Connect'))
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              }

              return Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Future<void> onConnectTap(RequestModel device) async {
    final sender = SenderTransfer(ip: device.ipAddress);
    await sender.init();
    print (sender.sender.readyState);
    if (sender.sender.readyState == WebSocket.open){
      sender.sender.add('connected');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => SendScreen(sender: sender)));
  }

  void handleMsg(req, p1) {
    if (p1 is String && p1 == 'connected'){
       Navigator.pushNamed(context, '/receive');
    } else  {
    }
  }
}
