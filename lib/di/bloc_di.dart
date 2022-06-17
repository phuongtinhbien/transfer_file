import 'package:get_it/get_it.dart';
import 'package:transfer_file/features/scan_code/scan_code_bloc.dart';

class BlocDI {
  BlocDI._();

  static Future<void> init(GetIt injector) async {
    injector.registerSingleton<ScanCodeBloc>(ScanCodeBloc());
  }
}
