import 'package:flutter/foundation.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

xmtp.Api createApi() =>
    // xmtp.Api.create(host: '127.0.0.1', port: 5556, isSecure: false)
// xmtp.Api.create(host: 'dev.xmtp.network', isSecure: true)
    xmtp.Api.create(
      host: 'dev.xmtp.network',
      port: 5556,
      isSecure: true,
      debugLogRequests: kDebugMode,
      appVersion: "dev/0.0.0-development",
    );
