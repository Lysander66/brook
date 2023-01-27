import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'global_config.g.dart';

@JsonSerializable()
class GlobalConfig {
  String language;
  String theme;
  bool isDarkMode;

  GlobalConfig({
    required this.language,
    this.theme = '',
    this.isDarkMode = false,
  });

  factory GlobalConfig.fromJson(Map<String, dynamic> json) =>
      _$GlobalConfigFromJson(json);
  Map<String, dynamic> toJson() => _$GlobalConfigToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
