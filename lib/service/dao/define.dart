import 'package:brook/util/utils.dart';
import 'package:summer/summer.dart' as summer;

import 'music_dao.dart';

final defaultClient = summer.Client();

void initHttpClient(String env) {
  MusicDao.init(env);

  vlog.i('initHttpClient $env');
}
