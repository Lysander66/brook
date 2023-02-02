import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/player_controller.dart';
import '../model/vo/song.dart';
import 'song_screen.dart';

class MyFavoriteScreen extends StatelessWidget {
  final PlayerController playerController = Get.find();

  MyFavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('我的收藏'),
        ),
        body: SingleChildScrollView(
          child: Obx(() => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _PlaylistSongs(
                        playlist: playerController.myFavorites.value),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class _PlaylistSongs extends StatelessWidget {
  final PlayerController playerController = Get.find();

  final List<SongVo> playlist;

  _PlaylistSongs({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlist.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            playerController.startPlaying(playlist, index);
            Get.to(() => SongScreen());
          },
          leading: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          title: Text(
            playlist[index].name,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            '${playlist[index].name}·${playlist[index].arName}',
          ),
          trailing: IconButton(
            onPressed: () {
              Get.snackbar(
                '待办',
                'ListTile',
                margin: const EdgeInsets.all(20.0),
                duration: const Duration(seconds: 1),
              );
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        );
      },
    );
  }
}
