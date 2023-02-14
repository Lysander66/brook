# brook

Music app

[B 站](https://www.bilibili.com/video/BV1P841137UT/)

## Run

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run --release --dart-define=APP_ENV=prod
```

启动时通过 `--dart-define=APP_ENV=` 指定环境，若不指定则默认 dev

config_service.dart:14

```dart
static Future<void> init() async {
  const env = String.fromEnvironment('APP_ENV');

  await GetStorage.init();
  await ConfigCache.setEnvironment(env.isNotEmpty ? env : Environment.dev);
  initHttpClient(env.isNotEmpty ? env : Environment.dev);

  ...
}
```

配置不同环境的域名 `_hostDev` `_hostDev`

music_dao.dart:27

```dart
static const _hostProd = 'https://brook.vercel.app';
static const _hostDev = 'http://192.168.8.27:3000';
static const _search = '/cloudsearch';
static const _personalized = '/personalized';
static const _playlistDetail = '/playlist/detail';
static const _songUrl = '/song/url/v1';

static init(String env) {
  client = summer.Client(
    baseURL: env == Environment.prod ? _hostProd : _hostDev,
    udBeforeRequest: onBeforeRequest,
    afterResponse: onAfterResponse,
  );
}
```

Api 用的是[NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)，建议你自行部署。
演示地址(https://brook.vercel.app) 部署在 vercel 上，可能需要科学上网才能访问。

### i18n

- [get_cli](https://github.com/jonataslaw/get_cli)

```sh
get generate locales assets/locales
```

## thanks

- [Binaryify/NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)
- [dart-lang/http](https://pub.dev/packages/http)
- [bluefireteam/audioplayers](https://pub.dev/packages/audioplayers)
- [jonataslaw/getx](https://pub.dev/packages/get)
- [jonataslaw/get_cli](https://pub.dev/packages/get_cli)
- [jonataslaw/get_storage](https://pub.dev/packages/get_storage)
- [JulianAssmann/flutter_background](https://pub.dev/packages/flutter_background)
- ...
