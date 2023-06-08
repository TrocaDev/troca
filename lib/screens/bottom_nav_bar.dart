import 'package:flutter/material.dart';
import 'package:troca/screens/user/user_list_screen.dart';
import 'package:troca/screens/user/user_settings.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class BottomBar extends StatefulWidget {
  static const routeName = "/bottom-bar";
  const BottomBar({super.key, required this.client});

  final xmtp.Client client;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page == 0 ? UserListScreen(client: widget.client) : UserSettings(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //1 HOME
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(
                Icons.message_outlined,
              ),
            ),
            label: '',
          ),
          //2 Settings
          BottomNavigationBarItem(
            icon: Container(
              child: const Icon(
                Icons.settings_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
