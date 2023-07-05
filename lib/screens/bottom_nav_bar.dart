import 'package:flutter/material.dart';
import 'package:troca/screens/qr_code/qr_code.dart';
import 'package:troca/screens/user/test.dart';
import 'package:troca/screens/user/user_settings.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatefulWidget {
  static const routeName = "/bottom-bar";
  final xmtp.Client client;
  const BottomBar({super.key, required this.client});

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
      body: _page == 0
          ? TestScreen(client: widget.client)
          : _page == 1
              ? const UserSettings()
              : QRCode(),
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.message_outlined,
          ),
          GButton(
            icon: Icons.settings_outlined,
          ),
          GButton(
            icon: Icons.qr_code_2_sharp,
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
