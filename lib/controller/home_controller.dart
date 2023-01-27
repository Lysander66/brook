import 'package:brook/util/utils.dart';
import 'package:get/get.dart';

import '../model/dto/personalized.dart';
import '../model/dto/playlist.dart';
import '../model/vo/song.dart';
import '../service/dao/music_dao.dart';

class HomeController extends GetxController {
  final playlists = <Personalized>[].obs;
  final songs = <SongVo>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await personalized();
    await playlistDetail(playlists[0].id);
  }

  personalized() async {
    var resp = await MusicDao.personalized();
    playlists.value = resp.result;
    vlog.d(resp.toString());
  }

  Future<PlaylistResp> playlistDetail(int id) async {
    var resp = await MusicDao.playlistDetail(id);

    List<SongVo> list = [];
    for (var track in resp.playlist.tracks) {
      list.add(SongVo.fromTrack(track));
    }
    songs.value = list;
    return resp;
  }
}
