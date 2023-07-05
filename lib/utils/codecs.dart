import 'package:troca/utils/Int_codec.dart';
import 'package:troca/utils/attachment_codec.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

/// These are all the codecs supported in the app.
final xmtp.CodecRegistry codecs = xmtp.CodecRegistry()
  ..registerCodec(AttachmentCodec())
  ..registerCodec(IntegerCodec())
  ..registerCodec(xmtp.TextCodec());
