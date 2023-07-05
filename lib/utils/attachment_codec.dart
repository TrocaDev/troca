import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xmtp_proto/xmtp_proto.dart' as xmtp;

import 'package:xmtp/xmtp.dart';

final contentTypeAttachment = xmtp.ContentTypeId(
    authorityId: "troca",
    typeId: "attachment",
    versionMajor: 1,
    versionMinor: 0);

///C:\Users\wwwch\AppData\Local\Pub\Cache\hosted\pub.dev\xmtp-1.0.0\lib\src\content\codec_registry.dart
/// This is a [Codec] that supports Images
class AttachmentCodec extends Codec<Attachment> {
  @override
  xmtp.ContentTypeId get contentType => contentTypeAttachment;

  //Decoding function
  @override
  Future<Attachment> decode(EncodedContent content) {
    try {
      final mimeType = content.parameters['mimeType'];
      final filename = content.parameters['filename'];

      if (mimeType == null || filename == null) {
        print("INVALID FILE TYPE");
        throw ErrorDescription("Invalid File Type");
      }

      return Future.value(
        Attachment(
          filename: filename,
          mimeType: mimeType,
          data: content.content,
        ),
      );
    } on Exception catch (e) {
      print(e);
      throw ErrorDescription("Invalid File Type");
    }
  }

  //Encoding Function
  @override
  Future<xmtp.EncodedContent> encode(Attachment content) async {
    //
    final encodedContent = xmtp.EncodedContent(
      parameters: {
        "filename": content.filename,
        "mimeType": content.mimeType,
      },
      type: contentTypeAttachment,
      content: content.data,
    );

    return encodedContent;
  }
}

//Attachment Class
class Attachment {
  late String filename;
  late String mimeType;
  late List<int> data;

  Attachment(
      {required this.filename, required this.mimeType, required this.data});

  factory Attachment.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Attachment(
      filename: json['filename'],
      mimeType: json['mimeType'],
      data: base64Decode(json['data']),
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'filename': filename,
      'mimeType': mimeType,
      'data': base64Encode(data),
    });
  }
}


//XMTP CODEC

