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
                    Text(ethereum),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var mySecureStorage = const FlutterSecureStorage();
                        var conversationId =
                            await mySecureStorage.read(key: ethereum);
                        if (conversationId != null &&
                            conversationId.isNotEmpty) {
                          var convo = await client.newConversation(ethereum,
                              conversationId: conversationId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                client: client,
                                conversation: convo,
                              ),
                            ),
                          );
                        } else {
                          var convo = await client.newConversation(ethereum);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                client: client,
                                conversation: convo,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add),
                          Text("Start Conversation"),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
