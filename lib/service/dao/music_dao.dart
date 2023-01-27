import 'package:brook/util/utils.dart';
import 'package:summer/summer.dart' as summer;

import '../../common/constant/env.dart';
import '../../model/dto/personalized.dart';
import '../../model/dto/playlist.dart';
import '../../model/dto/search.dart';

class MusicDao {
  MusicDao._();

  static late summer.Client client;

  static const _hostProd = 'https://brook.vercel.app';
  static const _hostDev = 'https://brook.vercel.app';
  static const _personalized = '/personalized';
  static const _playlistDetail = '/playlist/detail';
  static const _search = '/cloudsearch';

  static init(String env) {
    client = summer.Client(
      baseURL: env == Environment.prod ? _hostProd : _hostDev,
    );
  }

  static Future<PersonalizedResp> personalized() async {
    final response = await client.R().get(_personalized);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return PersonalizedResp();
    }
    return PersonalizedResp.fromJson(response.data);
  }

  static Future<PlaylistResp> playlistDetail(int id) async {
    final response = await client
        .R()
        .setQueryParam('id', id.toString())
        .get(_playlistDetail);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return PlaylistResp();
    }
    return PlaylistResp.fromJson(response.data);
  }

  static Future<SearchResp> search(String keywords) async {
    final response =
        await client.R().setQueryParam('keywords', keywords).get(_search);

    if (response.data['code'] != 200) {
      vlog.e('code ${response.data['code']}');
      return SearchResp();
    }
    return SearchResp.fromJson(response.data);
  }
}
