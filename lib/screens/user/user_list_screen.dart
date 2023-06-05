import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:troca/services/xmtp_service.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

import '../../models/address_avatar.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key, required this.client});

  final xmtp.Client client;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<xmtp.Conversation> messages = [];
  bool _isLoading = false;
  final XmtpService xmtpService = XmtpService();

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
    List<xmtp.Conversation> fetchedItems =
        await xmtpService.listConversations(client: widget.client);

    setState(() {
      messages = fetchedItems;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Messages",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[50],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.add_outlined,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              // If messages are loading, show CircularIndicator else list messages
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return MessageListItem(message: messages[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> setMessages() async {
    messages = await xmtpService.listConversations(client: widget.client);
    return true;
  }
}

/// An item in the conversation's message list.
class MessageListItem extends StatelessWidget {
  final xmtp.Conversation message;

  MessageListItem({Key? key, required this.message})
      : super(key: Key(message.conversationId));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AddressAvatar(address: message.peer),
        ),
        title: Text(
          message.peer.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        horizontalTitleGap: 8,
        trailing: Text(
          DateFormat.jm().format(message.createdAt),
          style: const TextStyle(
            color: Color.fromARGB(255, 152, 151, 151),
          ),
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(
            "Messages that are sent and received will be shown here.",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: Color.fromARGB(255, 83, 83, 83), decorationThickness: 1),
          ),
        ),
        // onTap: () => context.go('/conversation/$topic'),
      ),
    );
  }
}