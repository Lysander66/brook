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

/*
  int previous() {
    _curr = _curr == 0 ? songs.length - 1 : _curr - 1;
    return _curr;
  }

  int next() {
    _curr = _curr == songs.length - 1 ? 0 : _curr + 1;
    return _curr;
  }
 */
}
