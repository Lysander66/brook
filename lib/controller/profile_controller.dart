import 'package:brook/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/global_config.dart';
import '../service/cache/config.dart';
import '../service/config_service.dart';
import '../service/dao/define.dart';

class ProfileController extends GetxController {
  final globalConfig = GlobalConfig(language: 'en_US').obs;
  var env = ''.obs;
  var host = 'ws://192.168.1.6:8080'.obs;

  @override
  void onInit() {
    super.onInit();
    env.value = ConfigCache.getEnvironment() ?? '';
    globalConfig.value = ConfigService.getGlobalConfig();
  }

  toggleDarkMode(bool isDarkMode) {
    // Get.changeTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
    //
    // globalConfig.value.isDarkMode = isDarkMode;
    // ConfigCache.setGlobalConfig(globalConfig.value);
  }

  updateLocale(String language) {
    if (globalConfig.value.language == language) {
      return;
    }
    var list = language.split('_');
    if (list.length != 2) {
      vlog.e('unsupported $language');
      return;
    }
    Get.updateLocale(Locale(list[0], list[1]));

    globalConfig.value.language = language;
    Get.snackbar('Language', language, duration: const Duration(seconds: 1));

    ConfigCache.setGlobalConfig(globalConfig.value);
  }

  switchEnv(String env) async {
    if (this.env.value == env) {
      return;
    }
    this.env.value = env;
    Get.snackbar('Env', env, duration: const Duration(seconds: 1));

    ConfigCache.setEnvironment(env);
    initHttpClient(env);
  }

  updateHost(String host) {
    this.host.value = host;
  }
}
