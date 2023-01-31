import 'package:brook/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constant/player.dart';
import '../controller/player_controller.dart';
import 'play_list.dart';

class SongScreen extends StatelessWidget {
  final PlayerController playerController = Get.find();

  SongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() => cachedNetworkImage(playerController.song.alPicUrl)),
          const _BackgroundFilter(),
          _MusicPlayer(),
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [
            0.0,
            0.4,
            0.6,
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  final PlayerController playerController = Get.find();

  _MusicPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      playerController.song.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      playerController.favorite();
                    },
                    iconSize: 30,
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                playerController.song.arName,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 50.0),
              // StreamBuilder<SeekBarData>(
              //     stream: _seekBarDataStream,
              //     builder: (context, snapshot) {
              //       final positionData = snapshot.data;
              //       return SeekBar(
              //         position: positionData?.position ?? Duration.zero,
              //         duration: positionData?.duration ?? Duration.zero,
              //       );
              //     }),
              SeekBar(
                position: playerController.position.value,
                duration: playerController.duration.value,
                onChanged: (Duration position) {
                  playerController.seek(position);
                },
              ),
              _Panel(),
            ],
          ),
        ));
  }
}

class _Panel extends StatelessWidget {
  final PlayerController playerController = Get.find();

  _Panel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                playerController.onPlaybackModeChanged();
              },
              iconSize: 30,
              icon: Icon(
                playerController.playbackMode == PlaybackMode.shuffle
                    ? Icons.shuffle
                    : playerController.playbackMode == PlaybackMode.repeatOne
                        ? Icons.repeat_one
                        : Icons.repeat,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                playerController.skipPrevious();
              },
              iconSize: 45,
              icon: const Icon(Icons.skip_previous, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                if (playerController.isPlaying) {
                  playerController.pause();
                } else {
                  playerController.resume();
                }
              },
              iconSize: 75,
              icon: Icon(
                playerController.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                playerController.skipNext();
              },
              iconSize: 45,
              icon: const Icon(Icons.skip_next, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                showPlayList(context);
                playerController.onQueue();
              },
              iconSize: 30,
              icon: const Icon(Icons.queue_music, color: Colors.white),
            ),
          ],
        ));
  }
}
