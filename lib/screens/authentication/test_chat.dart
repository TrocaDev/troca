import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:troca/attachment_codec.dart';
import 'package:troca/screens/chat/message_bubble.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:xmtp/xmtp.dart';
import 'package:mime/mime.dart';

import '../../session/foreground_session.dart';

class TestChatScreen extends StatefulWidget {
  static const routeName = "/test-chat-screen";
  const TestChatScreen(
      {super.key, required this.client, required this.conversation});

  final xmtp.Client client;
  final xmtp.Conversation conversation;

  @override
  State<TestChatScreen> createState() => _TestChatScreenState();
}

class _TestChatScreenState extends State<TestChatScreen> {
  TextEditingController _controller = TextEditingController();
  var messages = [];

  Stream<dynamic> useMessagesList() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      var messages = await session.findMessages(widget.conversation.topic);
      yield messages;
    }
  }

  File pickedImage = File('/data/user/0/com.example.troca/cache/pickImage.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 250,
          child: Text(
            widget.conversation.peer.toString(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: StreamBuilder(
              stream: session.watchMessages(widget.conversation.topic),
              builder: (context, snapshot) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    shrinkWrap: true,
                    itemCount:
                        (snapshot.data == null) ? 0 : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data![index].content.runtimeType ==
                          Attachment) {
                        Uint8List attachment =
                            snapshot.data![index].content.data;

                        return ImageBubble(
                          attachment,
                          (snapshot.data![index].sender ==
                              widget.conversation.me),
                          snapshot.data![index].sender.toString(),
                          snapshot.data![index].topic,
                          snapshot.data![index].sentAt,
                        );
                      }

                      debugPrint(
                        snapshot.data![index].content.runtimeType.toString(),
                      );

                      return MessageBubble(
                        snapshot.data![index].content,
                        (snapshot.data![index].sender ==
                            widget.conversation.me),
                        snapshot.data![index].sender.toString(),
                        snapshot.data![index].topic,
                        snapshot.data![index].sentAt,
                      );
                    });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onTap: () async {
                      final _picker = ImagePicker();
                      final _pickedImage = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                        maxHeight: 150,
                        maxWidth: 150,
                      );
                      final _pickedImageFile = File(_pickedImage!.path);
                      setState(() {
                        pickedImage = _pickedImageFile;
                      });
                      if (pickedImage.path == '') {
                        print("false");
                      } else {
                        var ImageData = await pickedImage.readAsBytes();
                        print(lookupMimeType(_pickedImage.path));

                        await widget.client.sendMessage(
                          widget.conversation,
                          Attachment(
                            filename: _pickedImage.name,
                            mimeType: lookupMimeType(_pickedImage.path)!,
                            data: ImageData,
                          ),
                          contentType: contentTypeAttachment,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.attachment_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        var name = result.files.single.name.toString();
                        var file = File(result.files.single.path!);
                        var image = Image.file(file);
                        var message = file.readAsBytesSync();
                        print(lookupMimeType(result.files.single.path!));
                        await widget.client.sendMessage(
                          widget.conversation,
                          Attachment(
                            filename: name,
                            mimeType:
                                lookupMimeType(result.files.single.path!)!,
                            data: message,
                          ),
                          contentType: contentTypeAttachment,
                        );
                      } else {
                        // User canceled the picker
                        return;
                      }
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.red[400],
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (_controller.text.isEmpty) {
                        return;
                      }
                      var x = await widget.client.sendMessage(
                        widget.conversation,
                        _controller.text,
                      );

                      print(x);

                      _controller.clear();
                    },
                    backgroundColor: Colors.red[400],
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
