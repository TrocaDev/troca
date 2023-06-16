import 'package:flutter/material.dart';
import 'package:troca/screens/chat/message_bubble.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat-screen";
  const ChatScreen(
      {super.key, required this.client, required this.conversation});

  final xmtp.Client client;
  final xmtp.Conversation conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  List<xmtp.DecodedMessage> messages = [];
  var listening;
  var listening2;

  //clear data stack
  void clear() async {
    await listening.cancel;
  }

  ///Init
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  //Load items
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    listening = widget.client.streamMessages(widget.conversation).listen(
      (message) {
        debugPrint('${message.sender} has a content of == ${message.content}');
        messages.add(message);
      },
      onError: (e) {
        print(e);
      },
    );

    List<xmtp.DecodedMessage> fetchedItems = await widget.client.listMessages(
        widget.conversation,
        sort: xmtp.SortDirection.SORT_DIRECTION_ASCENDING);

    setState(() {
      messages = fetchedItems;
      _isLoading = false;
    });
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: StreamBuilder(
                    stream: widget.client.streamMessages(widget.conversation),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          // reverse: true,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) => MessageBubble(
                            messages[index].content,
                            (messages[index].sender == widget.conversation.me),
                            messages[index].sender.toString(),
                            messages[index].topic,
                            messages[index].sentAt,
                          ),
                        );
                      }
                      if (snapshot.data != null) {}

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        // reverse: true,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) => MessageBubble(
                          messages[index].content,
                          (messages[index].sender == widget.conversation.me),
                          messages[index].sender.toString(),
                          messages[index].topic,
                          messages[index].sentAt,
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
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
