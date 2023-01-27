import 'package:brook/widget/image.dart';
import 'package:flutter/material.dart';

import '../model/dto/personalized.dart';

class PlaylistCard extends StatelessWidget {
  final Personalized playlist;

  /// avoid import cycle
  final VoidCallback onTap;

  const PlaylistCard({
    Key? key,
    required this.playlist,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onTap();
      },
      child: Container(
        height: 75,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade800.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: cachedNetworkImage(playlist.picUrl, width: 50, height: 50),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${playlist.trackCount} songs',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_circle,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
