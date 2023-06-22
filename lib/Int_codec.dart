import 'package:drift/drift.dart';
import 'package:xmtp_proto/xmtp_proto.dart' as xmtp;

import 'package:xmtp/xmtp.dart';

/// Example [Codec] for sending [int] values around.
final contentTypeInteger = xmtp.ContentTypeId(
  authorityId: "troca",
  typeId: "integer",
  versionMajor: 0,
  versionMinor: 1,
);

class IntegerCodec extends Codec<int> {
  @override
  xmtp.ContentTypeId get contentType => contentTypeInteger;

  @override
  Future<int> decode(xmtp.EncodedContent encoded) async {
    return Uint8List.fromList(encoded.content).buffer.asByteData().getInt64(0);
  }

  @override
  Future<xmtp.EncodedContent> encode(int decoded) async => xmtp.EncodedContent(
        type: contentType,
        content: Uint8List(8)..buffer.asByteData().setInt64(0, decoded),
        fallback: decoded.toString(),
      );
}
