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
  String nameEllipsis;
  String arNameEllipsis;

  SongVo({
    this.id = 0,
    this.name = '',
    this.alPicUrl = '',
    this.arName = '',
    this.nameEllipsis = '',
    this.arNameEllipsis = '',
  });

  factory SongVo.fromJson(Map<String, dynamic> json) => _$SongVoFromJson(json);

  Map<String, dynamic> toJson() => _$SongVoToJson(this);

  factory SongVo.fromTrack(Track track) {
    var item = SongVo(
      id: track.id,
      name: track.name,
      alPicUrl: track.al.picUrl,
      arName: track.artistName,
      nameEllipsis: ellipsis(track.name),
      arNameEllipsis: ellipsis(track.artistName),
    );
    return item;
  }

  static String ellipsis(String name) {
    return name.length <= 8 ? name : '${name.substring(0, 8)}...';
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
