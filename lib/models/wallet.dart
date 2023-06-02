// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:troca/models/test_connecter.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class WalletPage extends StatefulWidget {
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

  //DISPOSE
  @override
  void dispose() {
    super.dispose();
  }

  //Init
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () => copyAddressToClipboard());
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
                  xmtpC();
                },
                child: const Text("XMTP SIGNING"))
          ]),
        )),
      ),
    );
  }

  // REQUEST WALLET FOR SIGNER
  xmtp.Signer asSigner() {
    final wc = widget.connector.getWalletConnect();
    if (wc.session.accounts.isEmpty) {
      throw WalletConnectException("no accounts available for signing");
    }
    var address = wc.session.accounts.first;
    return xmtp.Signer.create(
        address,
        (text) => wc.sendCustomRequest(
              method: "personal_sign",
              params: [text, address],
            ).then((res) => hexToBytes(res)));
  }

  //XMTP SIGNING
  Future<void> xmtpC() async {
    var wallet = asSigner();
    var api = xmtp.Api.create();
    final mySecureStorage = const FlutterSecureStorage();
    widget.connector.openWalletApp();

    // ignore: unused_local_variable

    xmtp.Client? client =
        await xmtp.Client.createFromWallet(api, wallet).then((value) async {
      await mySecureStorage.write(
          //Saving the keys into Local Storage
          key: "xmtp.keys",
          value: value.keys.writeToJson());
      debugPrint(value.keys.toString());
    }).timeout(const Duration(seconds: 120));

    //NAVIGATING TO NEXT PAGE
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("SUCCESSFUL")),
        ),
      ),
    );
  }

  // late xmtp.PrivateKeyBundle x = xmtp.PrivateKeyBundle();

  //Copying the Address to clipboard
  void copyAddressToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.connector.address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Address copied!'),
      ),
    );
  }
}
