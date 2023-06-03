// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

// import '../../models/address_avatar.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key, required this.client});

  final xmtp.Client client;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  List<xmtp.Conversation> messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    await setMessages();
    List<xmtp.Conversation> fetchedItems = await listConversations();

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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: messages.length,

              // separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.brown),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("FROM: ${messages[index].peer.toString()}"),
                  subtitle: Text("TOPIC: ${messages[index].topic.toString()}"),
                );
              },
              reverse: true,
            ),
    );
  }

  Future<List<xmtp.Conversation>> listConversations({
    DateTime? start,
    DateTime? end,
    int? limit,
    xmtp.SortDirection? sort = xmtp.SortDirection.SORT_DIRECTION_DESCENDING,
  }) async {
    var conversations = await widget.client.listConversations();

    return conversations;
  }

  Future<bool> setMessages() async {
    messages = await listConversations();
    return true;
  }
}

/// An item in the conversation's message list.
// class MessageListItem extends StatelessWidget {
//   final xmtp.Conversation message;

//   MessageListItem({Key? key, required this.message})
//       : super(key: Key(message.conversationId));

  // @override
  // Widget build(BuildContext context) {
  //   return ListTile(
  //     leading: AddressAvatar(address: message.peer),
  //     title: Text(message.peer as String),
  //     horizontalTitleGap: 8,
  //     trailing: Text(DateFormat.jm().format(message.createdAt)),
  //     subtitle: Padding(
  //       padding: const EdgeInsets.only(left: 12.0),
  //       child: Text(message.topic[1]),
  //     ),
  //     // onTap: () => context.go('/conversation/$topic'),
  //   );
  // }
// }
