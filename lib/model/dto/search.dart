import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'playlist.dart';

part 'search.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchResp {
  late int code;
  late SearchResult result;

  SearchResp();

  factory SearchResp.fromJson(Map<String, dynamic> json) =>
      _$SearchRespFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRespToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class SearchResult {
  late int songCount;
  late List<Track> songs;

  SearchResult();

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
