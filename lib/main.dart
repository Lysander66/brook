import 'dart:io' show Platform, exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'generated/locales.g.dart';
import 'screen/screens.dart';
import 'service/config_service.dart';
import 'util/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.init();

  // 定时关闭
  Future.delayed(const Duration(minutes: 60), () {
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    if (Platform.isAndroid) {
      vlog.w('定时关闭');
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      vlog.w('iOS');
      exit(0);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music App',
      home: const HomePage(),
      theme: ThemeData(
          //TODO
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              )),
      locale: ConfigService.getLocale(),
      fallbackLocale: const Locale('en', 'US'),
      translationsKeys: AppTranslation.translations,
      builder: (context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            KeyboardUtils.hideKeyboard(context);
          },
          child: child,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
