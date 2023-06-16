// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:troca/models/test_connecter.dart';
import 'package:troca/screens/bottom_nav_bar.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:web3dart/crypto.dart';

import '../screens/user/user_list_screen.dart';

class XmtpService {
  xmtp.Signer asSigner({
    required TestConnector connector,
  }) {
    final wc = connector.getWalletConnect();
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
  Future<void> xmtpC({
    required TestConnector connector,
    required BuildContext context,
  }) async {
    var wallet = asSigner(connector: connector);
    //Explicitly defining APIs
    var api = xmtp.Api.create(
        host: 'dev.xmtp.network',
        port: 5556,
        isSecure: true,
        debugLogRequests: kDebugMode,
        appVersion: "dev/0.0.0-development");

    //Initializing Flutter Secure Storage Instance
    const mySecureStorage = FlutterSecureStorage();
    connector.openWalletApp();

    // ignore: unused_local_variable
    xmtp.Client client;

    client = await xmtp.Client.createFromWallet(api, wallet);
    await mySecureStorage.write(
        //Saving the keys into Local Storage
        key: "xmtp.keys",
        value: client.keys.writeToJson());
    debugPrint(client.keys.toString());

    //NAVIGATING TO NEXT PAGE
    Navigator.of(context).pushNamed(
      // MaterialPageRoute(
      //   builder: (context) => UserListScreen(client: client),
      // ),
      BottomBar.routeName,
      arguments: client,
    );
  }

  //Copying the Address to clipboard
  void copyAddressToClipboard({
    required TestConnector connector,
    required BuildContext context,
  }) {
    Clipboard.setData(ClipboardData(text: connector.address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('Address copied!'),
      ),
    );
  }

  /// This runs when the user logs out.
  /// It kills the background isolate, clears their authorized keys, and
  /// empties the database.
// Future<void> clear() async {
//   var prefs = await SharedPreferences.getInstance();
//   await prefs.remove('xmtp.keys');
//   initialized = false;
//   notifyListeners();
// }

//Listing Conversations
  Future<List<xmtp.Conversation>> listConversations({
    required xmtp.Client client,
    DateTime? start,
    DateTime? end,
    int? limit,
    xmtp.SortDirection? sort = xmtp.SortDirection.SORT_DIRECTION_DESCENDING,
  }) async {
    var conversations = await client.listConversations();

    return conversations;
  }
}
