import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../dto/playlist.dart';

part 'song.g.dart';

@JsonSerializable(explicitToJson: true)
class SongVo {
  int id;
  String name;
  String alPicUrl;
  String arName;
  int isFavorite;

  SongVo({
    this.id = 0,
    this.name = '',
    this.alPicUrl = '',
    this.arName = '',
    this.isFavorite = 0,
  });

  factory SongVo.fromJson(Map<String, dynamic> json) => _$SongVoFromJson(json);

  Map<String, dynamic> toJson() => _$SongVoToJson(this);

  factory SongVo.fromTrack(Track track) {
    var item = SongVo(
      id: track.id,
      name: track.name,
      alPicUrl: track.al.picUrl,
      arName: track.artistName,
    );
    return item;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
