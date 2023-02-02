import 'package:brook/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/res/r.dart';
import '../controller/home_controller.dart';
import '../controller/player_controller.dart';
import '../generated/locales.g.dart';
import '../model/dto/playlist.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  final homeController = Get.put(HomeController());
  final playerController = Get.put(PlayerController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
            appBar: const _CustomAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _DiscoverMusic(),
                  _TrendingMusic(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SectionHeader(
                          title: LocaleKeys.home_playlists.tr,
                          action: LocaleKeys.home_more.tr,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeController.playlists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PlaylistCard(
                              playlist: homeController.playlists[index],
                              onTap: () async {
                                final playlistDetail =
                                    await homeController.playlistDetail(
                                        homeController.playlists[index].id);
                                Get.to(() => PlaylistScreen(
                                    playlist: playlistDetail.playlist));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(Icons.grid_view_rounded),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: const CircleAvatar(
            backgroundImage: AssetImage(R.imagesAvatar),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _DiscoverMusic extends StatelessWidget {
  final HomeController homeController = Get.find();

  _DiscoverMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.home_welcome.tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5),
          Text(
            LocaleKeys.home_enjoy.tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: LocaleKeys.home_search.tr,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black),
            onFieldSubmitted: (String keyword) async {
              if (keyword.isNotEmpty) {
                var resp = await homeController.search(keyword);
                var playlist = Playlist(
                  name: '搜索结果',
                  coverImgUrl:
                      'http://p2.music.126.net/ss5Rm0q7UIV1cMvUid-tbw==/5727356069142637.jpg?param=177y177',
                  tracks: resp.result.songs,
                );
                Get.to(() => PlaylistScreen(playlist: playlist));
              }
            },
          )
        ],
      ),
    );
  }
}

class _TrendingMusic extends StatelessWidget {
  final HomeController homeController = Get.find();
  final PlayerController playerController = Get.find();

  _TrendingMusic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: SectionHeader(
                  title: LocaleKeys.home_trending.tr,
                  action: LocaleKeys.home_more.tr,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.27,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeController.songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SongCard(
                      song: homeController.songs[index],
                      onTap: () {
                        playerController.startPlaying(
                            homeController.songs, index);
                        Get.to(() => SongScreen());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
