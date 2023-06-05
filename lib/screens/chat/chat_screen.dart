import 'package:flutter/material.dart';
import 'package:troca/screens/chat/message_bubble.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.client, required this.conversation});

  final xmtp.Client client;
  final xmtp.Conversation conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;
  List<xmtp.DecodedMessage> messages = [];
  var listening;

  ///Init
  @override
  void initState() {
    super.initState();
    listening =
        widget.client.streamMessages(widget.conversation).listen((message) {
      debugPrint('${message.sender} has a content of == ${message.content}');
    });
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    List<xmtp.DecodedMessage> fetchedItems = await widget.client.listMessages(
      widget.conversation,
    );

    print(fetchedItems.length);

    setState(() {
      messages = fetchedItems;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => MessageBubble(
                  messages[index].content,
                  false,
                  messages[index].sender.toString(),
                  messages[index].topic,
                ),
              ),
            ),
    );
  }
}
