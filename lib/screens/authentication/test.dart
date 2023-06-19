import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:troca/screens/authentication/test_chat.dart';
import 'package:troca/screens/search/search_user.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

import '../../models/address_avatar.dart';
import '../../session/foreground_session.dart';

class TestScreen extends StatefulWidget {
  static const routeName = "/test-screen";
  const TestScreen({
    super.key,
    required this.client,
  });

  final xmtp.Client client;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ///Initial Variables
  List<xmtp.Conversation> messages = [];

  ///Screen UI
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        SearchUser.routeName,
                        arguments: widget.client,
                      );
                    },
                    child: Container(
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
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              /// If messages are loading, show CircularIndicator else list messages
              child: StreamBuilder(
                stream: useConversationList(),
                // initialData: useConversationList(),
                builder:
                    (context, AsyncSnapshot<List<xmtp.Conversation>> snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        (snapshot.data == null) ? 0 : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MessageListItem(
                        // message: messages[index],
                        message: snapshot.data![index],
                        client: widget.client,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<xmtp.Conversation>> useConversationList() async* {
    print("here");
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      var messages = await session.findConversations();
      yield messages;
    }
  }
}

/// Individual Conversation's UI
class MessageListItem extends StatelessWidget {
  final xmtp.Conversation message;
  final xmtp.Client client;

  MessageListItem({Key? key, required this.message, required this.client})
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
        onTap: () async {
          var friend = message.peer;
          var workTalk = await client.newConversation(
            friend.toString(),
            conversationId: message.conversationId,
            metadata: message.metadata,
          );
          print("Test Chat Screen");
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                TestChatScreen(client: client, conversation: workTalk),
          ));
        },
      ),
    );
  }
}
