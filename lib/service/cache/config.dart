import 'package:get_storage/get_storage.dart';

import '../../model/global_config.dart';

final box = GetStorage();

class ConfigCache {
  ConfigCache._();

  static const _environmentKey = 'environment';

  static const _globalConfigKey = 'globalConfig';

  static String? getEnvironment() {
    return box.read(_environmentKey);
  }

  static Future<void> setEnvironment(String env) async {
    box.write(_environmentKey, env);
  }

  static GlobalConfig? getGlobalConfig() {
    var value = box.read(_globalConfigKey);
    return value == null ? null : GlobalConfig.fromJson(value);
  }

  static Future<void> setGlobalConfig(GlobalConfig value) async {
    await box.write(_globalConfigKey, value.toJson());
  }
}
