import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/vo/song.dart';

class SongCard extends StatelessWidget {
  final SongVo song;

  /// avoid import cycle
  final VoidCallback onTap;

  const SongCard({
    Key? key,
    required this.song,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(song.alPicUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.37,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.nameEllipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      song.arNameEllipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.play_circle,
                  color: Colors.deepPurple,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
