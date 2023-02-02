import 'song.dart';

class PlaybackData {
  List<SongVo> songs = [];

  int _curr = -1;

  int get curr => _curr;

  void setCurr(int i) {
    _curr = i;
  }

  void reload(List<SongVo> tracks) {
    songs = tracks;
  }
}
