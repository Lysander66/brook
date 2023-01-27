import 'package:audioplayers/audioplayers.dart';
import 'package:brook/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/constant/player.dart';
import '../generated/locales.g.dart';
import '../service/dao/music_dao.dart';

class PlayerController extends GetxController {
  final AudioPlayer _player = audioPlayer;

  final _playbackModes = [
    PlaybackMode.repeatAll,
    PlaybackMode.repeatOne,
    PlaybackMode.shuffle
  ];
  var index = 0.obs;

  get playbackMode => _playbackModes[index.value];

  @override
  onInit() {
    super.onInit();
    _player.onPositionChanged.listen((event) {
      vlog.d('onPositionChanged $event');
    });
  }

  Future<void> onPlay(int id) async {
    final url = await MusicDao.songUrl(id);
    vlog.i('播放: $url');
    var source = UrlSource(url);
    _player.play(source);
  }

  void onResumeOrPause() {
    vlog.i('pause or resume');
  }

  void onNext() {
    vlog.i('next');
  }

  void onPrevious() {
    vlog.i('onPrevious');
  }

  void onFavorite() {
    vlog.i('favorite');
  }

  void onPlaybackModeChanged() {
    index.value =
        index.value == _playbackModes.length - 1 ? 0 : index.value + 1;

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
}
