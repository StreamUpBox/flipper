// import 'package:flipper/model/flipper_config.dart';
library flipper_services;

// import 'package:flipper/proxy.dart';
import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pusher/pusher.dart';

class PusherService {
  Future syncToClients() async {
    final FlipperConfig flipperConfig =
        await ProxyService.firestore.getConfigs();

    final Pusher pusher = Pusher(
        flipperConfig.pusherAppId,
        flipperConfig.pusherAppKey,
        flipperConfig.pusherAppSecret,
        PusherOptions(cluster: 'ap2'));
    final Map data = {'message': 'sync-clients'};
    //first sync is channel and the second is event
    try {
      await pusher.trigger(['sync'], 'sync', data);
      // ignore: empty_catches
    } catch (e) {} //in case of internet not available
  }
}
