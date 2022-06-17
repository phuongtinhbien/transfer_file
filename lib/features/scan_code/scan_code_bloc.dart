import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:transfer_file/di/app_injector.dart';
import 'package:transfer_file/network/network_wifi.dart';

part 'scan_code_event.dart';
part 'scan_code_state.dart';

class ScanCodeBloc extends Bloc<ScanCodeEvent, ScanCodeState> {
  ScanCodeBloc() : super(ScanCodeInitial()) {
    on<GenQRCodeEvent>(_doGenQRCode);
    on<ScanCodeEvent>(_doScanCode);
  }

  FutureOr<void> _doGenQRCode(GenQRCodeEvent event, Emitter<ScanCodeState> emit) {

    try {
      emit(OnGenQRCode());
      final data = {
        'ip_address': AppInjector.injector<NetworkWifi>().wifiIP,
        'wifi_name': AppInjector.injector<NetworkWifi>().wifiName
      };

      emit(GenQRCodeSuccess(jsonEncode(data).toString()));

    } catch (e) {
      emit(GenQRCodeError());
    }
  }

  FutureOr<void> _doScanCode(ScanCodeEvent event, Emitter<ScanCodeState> emit) {
  }
}
