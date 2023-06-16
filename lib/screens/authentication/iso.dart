import 'dart:isolate';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:flutter/foundation.dart';

import '../../session/background_manager.dart';

void _mainXmtpIsolate(xmtp.Client client) async {
  final keys = client.keys;
  debugPrint('starting xmtp worker for ${keys.wallet}');
  final manager = await BackgroundManager.create(keys);
  manager.start();
}

void spawnIsolate(xmtp.Client client) async {
  await Isolate.spawn(_mainXmtpIsolate, client);
}
