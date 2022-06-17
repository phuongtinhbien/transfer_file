part of 'scan_code_bloc.dart';

@immutable
abstract class ScanCodeEvent {}


class GenQRCodeEvent extends ScanCodeEvent{}

class ScanQRCodeEvent extends ScanCodeEvent {}

