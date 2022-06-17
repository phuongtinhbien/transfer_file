import 'package:flutter/material.dart';
import 'package:transfer_file/app/app_config.dart';
import 'package:transfer_file/features/receive_screen/receive_screen.dart';
import 'package:transfer_file/features/scan_code/scan_code_screen.dart';
import 'package:transfer_file/features/send_screen/send_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/scan_code': (_) => ScanCodeScreen(),
        '/receive': (_) => ReceiveScreen(),
      },

      initialRoute: '/scan_code',
    );
  }
}

