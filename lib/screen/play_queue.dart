import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/player_controller.dart';

//设计图宽度
const _width = 750;

class Screen {
  late MediaQueryData screen;

  late num width, height, top;

  Screen(BuildContext context) {
    screen = MediaQuery.of(context);
    width = screen.size.width;
    height = screen.size.height;
    top = screen.padding.top;
  }

  double calc(num value) {
    return value * width / _width;
  }
}

void showQueue(BuildContext context) {
  final screen = Screen(context);

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.3),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, a1, a2) {
      return Theme(
        data: ThemeData(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned(
                    bottom: screen.calc(52),
                    left: screen.calc(30),
                    child: Container(
                      width: screen.calc(690),
                      height: screen.calc(908),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screen.calc(46)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          _Header(),
                          _List(),
                          _Footer(),
                        ],
                      ),
                    ))
              ],
            )),
      );
    },
  );
}

class _Header extends StatelessWidget {
  final PlayerController playerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screen = Screen(context);

    return Container(
      padding: EdgeInsets.only(
          left: screen.calc(32),
          right: screen.calc(32),
          bottom: screen.calc(18)),
      child: Obx(
        () => Column(children: [
          Padding(
              padding: EdgeInsets.only(top: screen.calc(38)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '当前播放',
                        style: TextStyle(
                            fontSize: screen.calc(36),
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: ' (85)',
                        style: TextStyle(
                            fontSize: screen.calc(32),
                            color: const Color(0xff999999))),
                  ]),
                )
              ])),
          Padding(
              padding: EdgeInsets.only(top: screen.calc(26)),
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        playerController.playbackModeIcon(),
                      ),
                      Text(playerController.playbackModeText())
                    ],
                  ),
                  const Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: screen.calc(32)),
                      child: Row(
                        children: const [
                          Icon(Icons.create_new_folder,
                              color: Color(0xff999999)),
                          Text('收藏全部')
                        ],
                      )),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(width: 1, color: Color(0xffe6e6e6))),
                    ),
                    padding: EdgeInsets.only(left: screen.calc(30)),
                    child: const Icon(Icons.delete, color: Color(0xff999999)),
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = Screen(context);
    const borderColor = Color(0xffe6e6e6);

    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: screen.calc(111),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1)),
          ),
          child: Center(
              child: Text('关闭', style: TextStyle(fontSize: screen.calc(32)))),
        ));
  }
}

class _List extends StatelessWidget {
  final PlayerController playerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screen = Screen(context);

    return Obx(() => Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: screen.calc(32), right: screen.calc(32)),
              child: Column(
                children: playerController.songs
                    .map((item) => _ListItem(
                          title: item.name,
                          artist: item.arName,
                          active: item.id == playerController.song.id,
                        ))
                    .toList(),
              ),
            ),
          ),
        ));
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final String artist;
  final bool active;

  const _ListItem(
      {Key? key,
      required this.title,
      required this.artist,
      this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = Screen(context);

    return Container(
        height: screen.calc(89),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe6e6e6))),
        ),
        child: Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screen.calc(26),
                        color: active
                            ? const Color(0xffeb534c)
                            : const Color(0xff333333),
                      )),
                  TextSpan(
                      text: ' - $artist',
                      style: TextStyle(
                          color: active
                              ? const Color(0xffeb534c)
                              : const Color(0xff666666),
                          fontSize: screen.calc(22))),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Icon(Icons.close, color: Color(0xff999999)),
          ],
        ));
  }
}
