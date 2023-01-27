import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'personalized.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonalizedResp {
  late bool hasTaste;
  late int code;
  late int category;
  late List<Personalized> result;

  PersonalizedResp();

  factory PersonalizedResp.fromJson(Map<String, dynamic> json) =>
      _$PersonalizedRespFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalizedRespToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class Personalized {
  late int id;
  late int type;
  late String name;
  late String copywriter;
  late String picUrl;
  late bool canDislike;
  late int trackNumberUpdateTime;
  late int playCount;
  late int trackCount;
  late bool highQuality;
  late String alg;

  Personalized();

  factory Personalized.fromJson(Map<String, dynamic> json) =>
      _$PersonalizedFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalizedToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
