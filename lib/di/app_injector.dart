
import 'package:get_it/get_it.dart';
import 'package:transfer_file/di/bloc_di.dart';
import 'package:transfer_file/di/device_di.dart';
import 'package:transfer_file/di/network_di.dart';

class AppInjector {
  AppInjector._();

  static final injector = GetIt.instance;

  static Future<void> initializeDependencies() async {
    await DeviceDI.init(injector);
    await BlocDI.init(injector);
    await NetWorkDI.init(injector);

  }
}
