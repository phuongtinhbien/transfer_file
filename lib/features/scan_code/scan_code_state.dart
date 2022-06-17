part of 'scan_code_bloc.dart';

@immutable
abstract class ScanCodeState {}

class ScanCodeInitial extends ScanCodeState {}

class OnGenQRCode extends ScanCodeState {}

class GenQRCodeSuccess extends ScanCodeState {
  final String qrCode;

  GenQRCodeSuccess(this.qrCode);
}

class GenQRCodeError extends ScanCodeState {

}
