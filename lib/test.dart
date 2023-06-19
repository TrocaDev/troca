// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:troca/models/test_connecter.dart';
import 'package:troca/services/xmtp_service.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool validateAddress = true;
  bool validateAmount = true;
  final XmtpService xmtpService = XmtpService();

  //DISPOSE
  @override
  void dispose() {
    super.dispose();
  }

  //UI for XMTP sign in page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text("address"),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {}, child: const Text("XMTP SIGNING"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
