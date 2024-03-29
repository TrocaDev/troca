import 'package:flutter/material.dart';
import 'package:troca/screens/authentication/test.dart';
import 'package:troca/screens/user/user_settings.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:google_nav_bar/google_nav_bar.dart';

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
      body:
          _page == 0 ? TestScreen(client: widget.client) : const UserSettings(),
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.message_outlined,
          ),
          GButton(
            icon: Icons.settings_outlined,
          ),
        ],
        iconSize: 28,
        activeColor: Colors.red[400],
        onTabChange: updatePage,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabBorderRadius: 20,
        curve: Curves.elasticIn,
        style: GnavStyle.google,
        selectedIndex: 0,
      ),
    );
  }
}
