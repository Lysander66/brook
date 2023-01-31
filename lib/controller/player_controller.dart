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

  final _playbackModes = [
    PlaybackMode.repeatAll,
    PlaybackMode.repeatOne,
    PlaybackMode.shuffle
  ];
  var playbackModeIndex = 0.obs;

  final data = PlaybackData().obs;
  final shuffleData = PlaybackData().obs;

  List<SongVo> get songs => playbackMode == PlaybackMode.shuffle
      ? shuffleData.value.songs
      : data.value.songs;

  SongVo get song => playbackMode == PlaybackMode.shuffle
      ? shuffleData.value.song
      : data.value.song;

  int get curr => playbackMode == PlaybackMode.shuffle
      ? shuffleData.value.curr
      : data.value.curr;

  PlaybackMode get playbackMode => _playbackModes[playbackModeIndex.value];

  bool get isPlaying => playerState.value == PlayerState.playing;

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
      vlog.d('onPositionChanged $position');
    });
  }

  void onCompleted() {
    switch (playbackMode) {
      case PlaybackMode.repeatAll:
        skipNext();
        break;
      case PlaybackMode.repeatOne:
        _play(song.id);
        break;
      case PlaybackMode.shuffle:
        reshuffle(song.id);
    }
  }

  void startPlaying(List<SongVo> tracks, int index) {
    if (tracks.isEmpty) {
      vlog.e('empty tracks');
      return;
    }
    if (index < 0 || index >= tracks.length) {
      vlog.e('index out of range: index:$index length:${tracks.length}');
      return;
    }

    //歌单原始顺序
    data.value.reload(tracks);

    int id = tracks[index].id;
    if (!_playWrap(id)) {
      return;
    }
    if (playbackMode == PlaybackMode.shuffle) {
      //随机播放
      reshuffle(id);
    } else {
      //列表循环 单曲循环
      data.value.findCurr(id);
      vlog.i('message ${song.id}');
    }
  }

  void reshuffle(int id) {
    shuffleData.value.reload(List<SongVo>.from(data.value.songs)..shuffle());
    shuffleData.value.findCurr(id);
  }

  void skipPrevious() {
    if (songs.length <= 1) {
      vlog.i('length:${songs.length}');
      return;
    }

    if (playbackMode == PlaybackMode.shuffle) {
      _play(songs[shuffleData.value.previous()].id);
      vlog.i('previous shuffle ${shuffleData.value.curr}');
    } else {
      _play(songs[data.value.previous()].id);
      vlog.i('previous repeat ${data.value.curr}');
    }
  }

  void skipNext() {
    if (songs.length <= 1) {
      vlog.i('length:${songs.length}');
      return;
    }

    if (playbackMode == PlaybackMode.shuffle) {
      _play(songs[shuffleData.value.next()].id);
      vlog.i('next shuffle ${shuffleData.value.curr}');
    } else {
      _play(songs[data.value.next()].id);
      vlog.i('next repeat ${data.value.curr}');
    }
  }

  bool _playWrap(int id) {
    if (song.id == id) {
      vlog.i('The same song: $id ${playerState.value}');
      return false;
    }
    _play(id);
    return true;
  }

  Future<void> _play(int id) async {
    final url = await MusicDao.songUrl(id);
    var source = UrlSource(url);
    // var source = AssetSource(url);
    _player.play(source);
    vlog.i('播放: $url');
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

  void onQueue() {
    vlog.d('onQueue');
  }

  void favorite() {
    song.isFavorite = 1 - song.isFavorite;
  }

  void onPlaybackModeChanged() {
    playbackModeIndex.value =
        playbackModeIndex.value == _playbackModes.length - 1
            ? 0
            : playbackModeIndex.value + 1;

    if (playbackMode == PlaybackMode.repeatAll) {
      data.value.findCurr(shuffleData.value.song.id);
      vlog.i('findCurr shuffle ${shuffleData.value.song.id}');
    } else if (playbackMode == PlaybackMode.shuffle) {
      reshuffle(data.value.song.id);
      vlog.i('findCurr ${song.id}');
    }

    Get.snackbar(
      LocaleKeys.playbackMode_name.tr,
      playbackModeText(),
      margin: const EdgeInsets.all(20.0),
      duration: const Duration(seconds: 2),
    );
  }

  IconData playbackModeIcon() {
    if (playbackMode == PlaybackMode.shuffle) {
      return Icons.shuffle;
    } else if (playbackMode == PlaybackMode.repeatOne) {
      return Icons.repeat_one;
    }
    return Icons.repeat;
  }

  String playbackModeText() {
    if (playbackMode == PlaybackMode.shuffle) {
      return LocaleKeys.playbackMode_shuffle.tr;
    } else if (playbackMode == PlaybackMode.repeatOne) {
      return LocaleKeys.playbackMode_repeatOne.tr;
    }
    return LocaleKeys.playbackMode_repeatAll.tr;
  }
}
