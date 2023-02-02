import 'package:audioplayers/audioplayers.dart';
import 'package:brook/model/vo/song.dart';
import 'package:brook/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constant/player.dart';
import '../generated/locales.g.dart';
import '../model/vo/playback_data.dart';
import '../service/dao/music_dao.dart';

class PlayerController extends GetxController {
  final AudioPlayer _player = audioPlayer;

  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var playerState = PlayerState.stopped.obs;
  bool get isPlaying => playerState.value == PlayerState.playing;

  final _playbackModes = [
    PlaybackMode.repeatAll,
    PlaybackMode.repeatOne,
    PlaybackMode.shuffle
  ];
  var playbackModeIndex = 0.obs;
  PlaybackMode get playbackMode => _playbackModes[playbackModeIndex.value];

  // 歌单原始顺序
  final data = PlaybackData().obs;

  // 随机顺序
  final shuffleIndexes = <int>[].obs;

  // 播放队列
  List<SongVo> get songs {
    if (playbackMode == PlaybackMode.shuffle) {
      return shuffleIndexes.map((i) => data.value.songs[i]).toList();
    }
    return data.value.songs;
  }

  int get curr => data.value.curr;

  SongVo get song {
    if (songs.isEmpty || curr < 0) {
      return SongVo();
    }
    if (playbackMode == PlaybackMode.shuffle) {
      int j = _findIndex(shuffleIndexes, curr);
      return songs[j];
    }
    return songs[curr];
  }

  @override
  onInit() {
    super.onInit();

    _player.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      if (state == PlayerState.completed) {
        onCompleted();
      }
    });

    _player.onDurationChanged.listen((duration) {
      this.duration.value = duration;
    });

    _player.onPositionChanged.listen((position) {
      this.position.value = position;
    });
  }

  void onCompleted() {
    if (playbackMode == PlaybackMode.repeatOne) {
      _play(song.id);
    } else {
      skip2Next();
    }
  }

  void reshuffle() {
    shuffleIndexes.value =
        List.generate(data.value.songs.length, (index) => index)..shuffle();
  }

  void startPlaying(List<SongVo> tracks, int i) {
    if (tracks.isEmpty) {
      vlog.w('empty tracks');
      return;
    }
    if (i < 0 || i >= tracks.length) {
      vlog.e('index out of range: index:$i length:${tracks.length}');
      return;
    }

    final id = tracks[i].id;
    final currentId = song.id;

    // 重新加载
    data.value.reload(tracks);
    if (playbackMode == PlaybackMode.shuffle) {
      reshuffle();
    }

    if (currentId == id) {
      vlog.d('The same song: $id $playerState');
      return;
    }

    data.value.setCurr(i);
    _play(id);
  }

  void playSelected(int id) {
    for (var i = 0; i < data.value.songs.length; i++) {
      if (data.value.songs[i].id == id) {
        data.value.setCurr(i);
        _play(id);
      }
    }
  }

  void skip2Previous() {
    if (songs.length <= 1) {
      return;
    }

    int prev = 0;
    if (playbackMode == PlaybackMode.shuffle) {
      int j = _findIndex(shuffleIndexes, curr);
      if (j == -1) {
        return;
      }
      prev = shuffleIndexes[_previous(j, shuffleIndexes.length)];
    } else {
      prev = _previous(curr, data.value.songs.length);
    }

    data.value.setCurr(prev);
    _play(songs[prev].id);
    vlog.d('skip to previous $prev');
  }

  void skip2Next() {
    if (songs.length <= 1) {
      return;
    }

    int next = 0;
    if (playbackMode == PlaybackMode.shuffle) {
      int j = _findIndex(shuffleIndexes, curr);
      if (j == -1) {
        return;
      }
      next = shuffleIndexes[_next(j, shuffleIndexes.length)];
    } else {
      next = _next(curr, data.value.songs.length);
    }

    data.value.setCurr(next);
    _play(songs[next].id);
    vlog.d('skip to next $next');
  }

  Future<void> _play(int id) async {
    final url = await MusicDao.songUrl(id);
    _player.play(UrlSource(url));
    vlog.d('播放: $url');
  }

  void pause() {
    _player.pause();
  }

  void resume() {
    _player.resume();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void onPlaybackModeChanged() {
    playbackModeIndex.value =
        _next(playbackModeIndex.value, _playbackModes.length);

    if (playbackMode == PlaybackMode.shuffle) {
      reshuffle();
    }
  }

  int _previous(int current, int length) {
    return current - 1 < 0 ? length - 1 : current - 1;
  }

  int _next(int current, int length) {
    return current + 1 > length - 1 ? 0 : current + 1;
  }

  int _findIndex(List<int> arr, int val) {
    for (var i = 0; i < arr.length; i++) {
      if (val == arr[i]) {
        return i;
      }
    }
    vlog.e('$val not found in $arr');
    return -1;
  }

  IconData playbackModeIcon() {
    return playbackMode == PlaybackMode.shuffle
        ? Icons.shuffle
        : playbackMode == PlaybackMode.repeatOne
            ? Icons.repeat_one
            : Icons.repeat;
  }

  String playbackModeText() {
    return playbackMode == PlaybackMode.shuffle
        ? LocaleKeys.playbackMode_shuffle.tr
        : playbackMode == PlaybackMode.repeatOne
            ? LocaleKeys.playbackMode_repeatOne.tr
            : LocaleKeys.playbackMode_repeatAll.tr;
  }
}
