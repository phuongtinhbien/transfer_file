import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_file/di/app_injector.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  Future<void> init() async {
    await EasyLocalization.ensureInitialized();
    await AppInjector.initializeDependencies();

    _configLoading();
  }

  void _configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 30.0
      ..radius = 10.0
      ..userInteractions = true
      ..textStyle = GoogleFonts.montserrat(color: Colors.white)
      ..dismissOnTap = false;
  }
}
