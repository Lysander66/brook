import 'dart:convert';

import '../../model/vo/song.dart';
import 'config.dart';

class MyFavoriteCache {
  MyFavoriteCache._();

  static const _myFavoriteKey = 'myFavorite';

  static List<SongVo> get() {
    var result = box.read(_myFavoriteKey);
    if (result == null) {
      return [];
    }
    return (jsonDecode(result) as List<dynamic>)
        .map((e) => SongVo.fromJson(e))
        .toList();
  }

  static Future<void> set(List<SongVo> value) async {
    await box.write(_myFavoriteKey, jsonEncode(value));
  }
}
