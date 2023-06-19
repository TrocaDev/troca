// ignore_for_file: use_build_context_synchronously

import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../chat/chat_screen.dart';

class SearchResult extends StatelessWidget {
  static const routeName = "/search-result";
  const SearchResult({super.key, required this.ethereum, required this.client});
  final String ethereum;

  final xmtp.Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ethereum == ""
              ? const Text("NOT A VALID INPUT")
              : Column(
                  children: [
                    const Text("Start a conversation with"),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      ethereum,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.6),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () async {
                          var mySecureStorage = const FlutterSecureStorage();
                          var conversationId =
                              await mySecureStorage.read(key: ethereum);
                          if (conversationId != null &&
                              conversationId.isNotEmpty) {
                            var convo = await client.newConversation(ethereum,
                                conversationId: conversationId);
                            Navigator.of(context).pushNamed(
                              ChatScreen.routeName,
                              arguments: [client, convo],
                            );
                          } else {
                            var convo = await client.newConversation(ethereum);
                            Navigator.of(context).pushReplacementNamed(
                              ChatScreen.routeName,
                              arguments: [client, convo],
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.red[400],
                              size: 28,
                            ),
                            Text(
                              "Start Conversation",
                              style: TextStyle(color: Colors.red[400]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
