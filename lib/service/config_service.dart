import 'package:brook/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../common/constant/env.dart';
import '../model/global_config.dart';
import 'cache/config.dart';
import 'dao/define.dart';

class ConfigService {
  static Future<void> init() async {
    const env = String.fromEnvironment('AppEnvironment');

    await GetStorage.init();
    await ConfigCache.setEnvironment(env.isNotEmpty ? env : Environment.dev);
    initHttpClient(env.isNotEmpty ? env : Environment.dev);

    final fileName = envFileName(env);
    if (fileName.isNotEmpty) {
      await dotenv.load(fileName: fileName);
      vlog.i('load $fileName');
      vlog.d(dotenv.env['FOOBAR']);
    }
  }

  static String envFileName(String env) {
    switch (env) {
      case Environment.dev:
        return '.env.development';
      case Environment.prod:
        return '.env.production';
      default:
    }
    return '';
  }

  static GlobalConfig getGlobalConfig() {
    var value = ConfigCache.getGlobalConfig();
    if (value != null) {
      vlog.d('read: $value');
      return value;
    }
    // initialize
    var defaultGlobalConfig = GlobalConfig(language: 'en_US');
    vlog.d('default: $defaultGlobalConfig');
    return defaultGlobalConfig;
  }

  static Locale? getLocale() {
    var language = getGlobalConfig().language;
    var list = language.split('_');
    if (list.length != 2) {
      vlog.e('unsupported $language');
      return Get.deviceLocale;
    }
    return Locale(list[0], list[1]);
  }

  static ThemeData getThemeData() {
    var isDarkMode = getGlobalConfig().isDarkMode;
    return isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
