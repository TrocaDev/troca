// ignore_for_file: use_build_context_synchronously

import 'package:go_router/go_router.dart';
import 'package:troca/session/foreground_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../routes/app_route_constants.dart';

class SearchResult extends StatelessWidget {
  static const routeName = "/search-result";
  const SearchResult({super.key, required this.ethereum});
  final String ethereum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ethereum == ""
              ? Center(child: Text("NOT A VALID ADDRESS : $ethereum"))
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
                            var convo = await session.newConversation(ethereum,
                                conversationId: conversationId);
                            var conversation =
                                await session.findConversation(convo);
                            // Navigator.of(context).pushNamed(
                            //   TestChatScreen.routeName,
                            //   arguments: [conversation],
                            // );
                            GoRouter.of(context).pushReplacementNamed(
                              TrocaRouteConstants.testChatScreenRoute,
                              extra: conversation,
                            );
                          } else {
                            var convo = await session.newConversation(ethereum);
                            var conversation =
                                await session.findConversation(convo);
                            // Navigator.of(context).pushReplacementNamed(
                            //   TestChatScreen.routeName,
                            //   arguments: [conversation],
                            // );
                            GoRouter.of(context).pushReplacementNamed(
                              TrocaRouteConstants.testChatScreenRoute,
                              extra: conversation,
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
