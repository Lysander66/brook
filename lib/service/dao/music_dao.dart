import 'package:brook/util/utils.dart';
import 'package:summer/summer.dart' as summer;

import '../../common/constant/env.dart';
import '../../model/dto/personalized.dart';
import '../../model/dto/playlist.dart';
import '../../model/dto/search.dart';

class MusicDao {
  MusicDao._();

  static late summer.Client client;

  static const _realIP = '111.59.95.32';
  static const _hostProd = 'https://brook.vercel.app';
  static const _hostDev = 'http://192.168.8.27:3000';
  static const _search = '/cloudsearch';
  static const _personalized = '/personalized';
  static const _playlistDetail = '/playlist/detail';
  static const _songUrl = '/song/url/v1';

  static init(String env) {
    client = summer.Client(
      baseURL: env == Environment.prod ? _hostProd : _hostDev,
    );
  }

  static Future<SearchResp> search(String keywords) async {
    final response = await client
        .R()
        .setQueryParam('realIP', _realIP)
        .setQueryParam('keywords', keywords)
        .get(_search);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return SearchResp();
    }
    return SearchResp.fromJson(response.data);
  }

  static Future<PersonalizedResp> personalized() async {
    final response =
        await client.R().setQueryParam('realIP', _realIP).get(_personalized);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return PersonalizedResp();
    }
    return PersonalizedResp.fromJson(response.data);
  }

  static Future<PlaylistResp> playlistDetail(int id) async {
    final response = await client
        .R()
        .setQueryParam('realIP', _realIP)
        .setQueryParam('id', id.toString())
        .get(_playlistDetail);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return PlaylistResp();
    }
    return PlaylistResp.fromJson(response.data);
  }

  static Future<String> songUrl(int id) async {
    final response = await client
        .R()
        .setQueryParam('realIP', _realIP)
        .setQueryParam('id', id.toString())
        .setQueryParam('level', 'exhigh')
        .get(_songUrl);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return fixedUrl(id);
    }
    for (var val in (response.data['data'] as List<dynamic>)) {
      var url = (val as Map<String, dynamic>)['url'] as String?;
      if (url != null && url.isNotEmpty) {
        return url.replaceFirst('http://', 'https://');
      }
    }
    return fixedUrl(id);
  }

  static String fixedUrl(int id) =>
      'https://music.163.com/song/media/outer/url?id=$id.mp3';
}
