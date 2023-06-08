// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:troca/models/test_connecter.dart';
import 'package:troca/services/xmtp_service.dart';

class WalletPage extends StatefulWidget {
  static const routeName = "/xmtp-signing";
  const WalletPage({
    required this.connector,
    Key? key,
  }) : super(key: key);

  final TestConnector connector;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool validateAddress = true;
  bool validateAmount = true;
  final XmtpService xmtpService = XmtpService();

  //DISPOSE
  @override
  void dispose() {
    super.dispose();
  }

  //Init
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 1),
        () => xmtpService.copyAddressToClipboard(
            connector: widget.connector, context: context));
    super.initState();
  }

  //UI for XMTP sign in page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Column(children: [
            Text(widget.connector.address),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  xmtpService.xmtpC(
                    connector: widget.connector,
                    context: context,
                  );
                },
                child: const Text("XMTP SIGNING"))
          ]),
        )),
      ),
    );
  }
}
