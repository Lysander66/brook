import 'package:brook/util/utils.dart';
import 'package:get/get.dart';

import '../model/vo/song.dart';
import '../service/cache/my_favorite_cache.dart';

class MyFavoriteController extends GetxController {
  // 我的收藏
  List<SongVo> myFavorites = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    myFavorites = MyFavoriteCache.get();

    //TODO
    List<SongVo> tmp = [];
    for (var v in myFavorites) {
      if (v.isFavorite == 1) {
        tmp.add(v);
      }
    }
    vlog.d('${myFavorites.length} ${tmp.length}');
    MyFavoriteCache.set(tmp);
    myFavorites = tmp;
  }

  void favorite(SongVo song) {
    if (song.isFavorite == 1) {
      if (!myFavorites.contains(song)) {
        myFavorites.insert(0, song);
        vlog.d('add ${song.id}');
      }
      return;
    }

    for (var v in myFavorites) {
      if (v.id == song.id) {
        v.isFavorite = 0;
      }
    }
    // myFavorites.remove(song);
    vlog.d('remove ${song.id}');

    MyFavoriteCache.set(myFavorites);
  }
}
