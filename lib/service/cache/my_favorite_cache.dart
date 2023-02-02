import '../../model/vo/song.dart';
import 'config.dart';

class MyFavoriteCache {
  MyFavoriteCache._();

  static const _myFavoriteKey = 'myFavorite';

  static List<SongVo> get() {
    List<SongVo>? value = box.read<List<SongVo>>(_myFavoriteKey);
    return value ?? [];
  }

  static Future<void> set(List<SongVo> value) async {
    await box.write(_myFavoriteKey, value);
  }
}
