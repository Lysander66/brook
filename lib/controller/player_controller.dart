import 'package:audioplayers/audioplayers.dart';
import 'package:brook/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/constant/player.dart';
import '../generated/locales.g.dart';
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

  PlaybackMode get playbackMode => _playbackModes[playbackModeIndex.value];

  bool get isPlaying => playerState.value == PlayerState.playing;

  @override
  onInit() {
    super.onInit();
    _player.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      vlog.i('state $state');
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

  Future<void> play(int id) async {
    final url = await MusicDao.songUrl(id);
    vlog.i('播放: $url');
    var source = UrlSource(url);
    // var source = AssetSource(url);
    _player.play(source);
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

  void skipPrevious() {
    vlog.i('previous');
  }

  void skipNext() {
    vlog.i('next');
  }
}
