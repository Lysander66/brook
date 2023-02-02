import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'playlist.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaylistResp {
  late int code;
  late Playlist playlist;
  late List<Privilege> privileges;

  PlaylistResp();

  factory PlaylistResp.fromJson(Map<String, dynamic> json) =>
      _$PlaylistRespFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistRespToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Playlist {
  late int id;
  late String name;
  late int coverImgId;
  late String coverImgUrl;
  late int adType;
  late int userId;
  late int createTime;
  late int status;
  late bool opRecommend;
  late bool highQuality;
  late bool newImported;
  late int updateTime;
  late int trackCount;
  late int specialType;
  late int privacy;
  late int trackUpdateTime;
  late String commentThreadId;
  late int playCount;
  late int trackNumberUpdateTime;
  late int subscribedCount;
  late int cloudTrackCount;
  late bool ordered;
  late String description;
  late List<String> tags;
  late List<PlaylistSubscribers> subscribers;
  late PlaylistCreator creator;
  late List<Track> tracks;
  late List<TrackId> trackIds;
  late int shareCount;
  late int commentCount;
  late String gradeStatus;

  Playlist({this.name = '', this.coverImgUrl = '', required this.tracks});

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class PlaylistSubscribers {
  late bool defaultAvatar;
  late int province;
  late int authStatus;
  late bool followed;
  late String avatarUrl;
  late int accountStatus;
  late int gender;
  late int city;
  late int birthday;
  late int userId;
  late int userType;
  late String nickname;
  late String signature;
  late String description;
  late String detailDescription;
  late int avatarImgId;
  late int backgroundImgId;
  late String backgroundUrl;
  late int authority;
  late bool mutual;
  late int vipType;
  late String avatarImgIdStr;
  late String backgroundImgIdStr;
  late bool anchor;

  PlaylistSubscribers();

  factory PlaylistSubscribers.fromJson(Map<String, dynamic> json) =>
      _$PlaylistSubscribersFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistSubscribersToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class PlaylistCreator {
  late bool defaultAvatar;
  late int province;
  late int authStatus;
  late bool followed;
  late String avatarUrl;
  late int accountStatus;
  late int gender;
  late int city;
  late int birthday;
  late int userId;
  late int userType;
  late String nickname;
  late String signature;
  late String description;
  late String detailDescription;
  late int avatarImgId;
  late int backgroundImgId;
  late String backgroundUrl;
  late int authority;
  late bool mutual;
  late int djStatus;
  late int vipType;
  late int authenticationTypes;
  late String avatarImgIdStr;
  late String backgroundImgIdStr;
  late bool anchor;

  PlaylistCreator();

  factory PlaylistCreator.fromJson(Map<String, dynamic> json) =>
      _$PlaylistCreatorFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistCreatorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class PlaylistCreatorAvatarDetail {
  late int userType;
  late int identityLevel;
  late String identityIconUrl;

  PlaylistCreatorAvatarDetail();

  factory PlaylistCreatorAvatarDetail.fromJson(Map<String, dynamic> json) =>
      _$PlaylistCreatorAvatarDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistCreatorAvatarDetailToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Track {
  late String name;
  late int id;
  late List<Artist> ar;
  late Album al;
  late int publishTime;

  Track();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);

  String get artistName {
    var name = '';
    for (int i = 0; i < ar.length; i++) {
      name += i == 0 ? ar[i].name : '/${ar[i].name}';
    }
    return name;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Artist {
  late int id;
  late String name;
  late List<dynamic> tns;
  late List<dynamic> alias;

  Artist();

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Album {
  late int id;
  late String name;
  late String picUrl;
  late List<dynamic> tns;
  late int pic;

  Album();

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class TrackId {
  late int id;
  late int v;
  late int t;
  late int at;
  late int uid;
  late String rcmdReason;

  TrackId();

  factory TrackId.fromJson(Map<String, dynamic> json) =>
      _$TrackIdFromJson(json);

  Map<String, dynamic> toJson() => _$TrackIdToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class Privilege {
  late int id;
  late int fee;
  late int payed;
  late int realPayed;
  late int maxbr;
  late int fl;
  late bool toast;
  late int flag;
  late bool paidBigBang;
  late bool preSell;
  late int playMaxbr;
  late int downloadMaxbr;
  late String maxBrLevel;
  late String playMaxBrLevel;
  late String downloadMaxBrLevel;
  late FreeTrialPrivilege freeTrialPrivilege;

  Privilege();

  factory Privilege.fromJson(Map<String, dynamic> json) =>
      _$PrivilegeFromJson(json);

  Map<String, dynamic> toJson() => _$PrivilegeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable(explicitToJson: true)
class FreeTrialPrivilege {
  late bool resConsumable;
  late bool userConsumable;

  FreeTrialPrivilege();

  factory FreeTrialPrivilege.fromJson(Map<String, dynamic> json) =>
      _$FreeTrialPrivilegeFromJson(json);

  Map<String, dynamic> toJson() => _$FreeTrialPrivilegeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
