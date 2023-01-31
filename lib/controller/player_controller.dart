import 'package:audioplayers/audioplayers.dart';
import 'package:brook/model/vo/song.dart';
import 'package:brook/util/utils.dart';
import 'package:flutter/cupertino.dart';
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

  // 歌单原始顺序
  final data = PlaybackData().obs;
  // 随机播放
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
        vlog.d('state $state');
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

  void onPlaybackModeChanged() {
    playbackModeIndex.value =
        playbackModeIndex.value == _playbackModes.length - 1
            ? 0
            : playbackModeIndex.value + 1;

    String message = playbackMode == PlaybackMode.shuffle
        ? LocaleKeys.playbackMode_shuffle.tr
        : playbackMode == PlaybackMode.repeatOne
            ? LocaleKeys.playbackMode_repeatOne.tr
            : LocaleKeys.playbackMode_repeatAll.tr;

    Get.snackbar(
      LocaleKeys.playbackMode_name.tr,
      message,
      margin: const EdgeInsets.all(20.0),
      duration: const Duration(seconds: 2),
    );
  }

  void onQueue() {
    vlog.i('onQueue');
  }

  void favorite() {
    vlog.i('favorite');
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

    data.value.reload(tracks);
    if (playbackMode == PlaybackMode.shuffle) {
      reshuffle();
    } else {
      data.value.setCurr(index);
      _play(tracks[index].id);
    }
  }

  void reshuffle() {
    var shuffleSongs = List<SongVo>.from(data.value.songs)..shuffle();
    shuffleData.value.reload(shuffleSongs);
    shuffleData.value.setCurr(0);
    _play(shuffleSongs[0].id);
  }

  void onCompleted() {
    switch (playbackMode) {
      case PlaybackMode.repeatAll:
        skipNext();
        break;
      case PlaybackMode.repeatOne:
        _player.seek(Duration.zero);
        break;
      case PlaybackMode.shuffle:
        reshuffle();
    }
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
}
