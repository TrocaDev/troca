import 'package:flutter/material.dart';
import 'package:troca/screens/chat/message_bubble.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

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
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  List<xmtp.DecodedMessage> messages = [];

  Stream<List<xmtp.DecodedMessage>> useMessagesList() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      var messages = await session.findMessages(widget.conversation.topic);
      yield messages;
    }
  }

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
                  // reverse: true,
                  shrinkWrap: true,
                  itemCount:
                      (snapshot.data == null) ? 0 : snapshot.data!.length,
                  itemBuilder: (context, index) => MessageBubble(
                    snapshot.data![index].content,
                    (snapshot.data![index].sender == widget.conversation.me),
                    snapshot.data![index].sender.toString(),
                    snapshot.data![index].topic,
                    snapshot.data![index].sentAt,
                  ),
                );
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
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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
                      await widget.client.sendMessage(
                        widget.conversation,
                        _controller.text,
                      );
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
