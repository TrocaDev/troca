// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:troca/models/wallet.dart';
import 'package:troca/screens/authentication/test.dart';
import 'package:troca/screens/bottom_nav_bar.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

import '../../models/ethereum_connecter.dart';
import '../../models/test_connecter.dart';
import '../../session/foreground_session.dart';

enum ConnectionState {
  Disconnected,
  connecting,
  connected,
  connectionFailed,
  connectionCancelled,
}

class AuthScreen extends StatefulWidget {
  static const routeName = "/authscreen";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = true;
  //TEST CONNECTERS
  TestConnector connector = EthereumTestConnector();

  //Connecting Networks
  static const _networks = ['Ethereum (Ropsten)'];

  //Initial conditions
  ConnectionState _state = ConnectionState.Disconnected;
  String? _networkName = _networks.first;

  //INIT FOR
  @override
  void initState() {
    connector.registerListeners(
        // connected
        (session) => debugPrint('Connected: $session'),
        // session updated
        (response) => debugPrint('Session updated: $response'),
        // disconnected
        () {
      setState(() => _state = ConnectionState.Disconnected);
      debugPrint('Disconnected');
    });
    super.initState();
  }

  //UI FOR LOGIN SCREEN
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Image.asset(
                  './lib/assets/bg-1-vertical.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // ignore: prefer_const_declarations

                            ///**Searching for Stored keys
                            const mySecureStorage = FlutterSecureStorage();
                            var x =
                                await mySecureStorage.read(key: "xmtp.keys");

                            if (x == null || x.isEmpty) {
                              //**IMPLEMENTATION IF USER ISN'T LOGGED IN */
                              debugPrint("Login");
                              _action(context, state: _state);
                              print(_state);
                            } else {
                              //**IMPLEMENTATION IF USER IS LOGGED IN PREVIOUSLY
                              setState(() {
                                isLoading = !isLoading;
                              });
                              var keys = xmtp.PrivateKeyBundle.fromJson(x);
                              debugPrint("$keys");
                              //Explicitly defining APIs
                              var api = xmtp.Api.create(
                                host: 'dev.xmtp.network',
                                port: 5556,
                                isSecure: true,
                                debugLogRequests: kDebugMode,
                                appVersion: "dev/0.0.0-development",
                              );
                              var client =
                                  await xmtp.Client.createFromKeys(api, keys);
                              setState(() {
                                isLoading = !isLoading;
                              });
                              // await session.authorizeLogin(client);
                              await session.testAuthorize(client);

                              print("TEST SCREEN");
                              //Navigating to next page
                              Navigator.of(context).pushNamed(
                                TestScreen.routeName,
                                arguments: client,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8859EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            minimumSize: Size(
                                0.9 * MediaQuery.of(context).size.width, 0),
                          ),
                          child: const Text(
                            'Connect Wallet',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'By continuing to use this app you agree to our Terms and Conditions and Privacy Policy.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  //TRANSACTION LIST
  String _transactionStateToString({required ConnectionState state}) {
    switch (state) {
      case ConnectionState.Disconnected:
        return 'Connect!!!';
      case ConnectionState.connecting:
        return 'Connecting';
      case ConnectionState.connected:
        return 'Session connected';
      case ConnectionState.connectionFailed:
        return 'Connection failed';
      case ConnectionState.connectionCancelled:
        return 'Connection cancelled';
    }
  }

  // NAVIGATE TO NEXT PAGE
  void _openWalletPage() {
    Navigator.of(context).pushNamed(WalletPage.routeName, arguments: connector);
  }

  // AUTHENTICATE DAPP USING WALLETS(METAMASK)
  //
  //**Implementation if user isn't logged in previously
  //
  Future<dynamic> _action(BuildContext context,
      {required ConnectionState state}) async {
    debugPrint('State: ${_transactionStateToString(state: state)}');
    switch (state) {
      // Progress, action disabled
      case ConnectionState.connecting:
        return null;
      case ConnectionState.connected:
        // Open new page
        return () => _openWalletPage();

      // Initiate the connection
      case ConnectionState.Disconnected:
      case ConnectionState.connectionCancelled:
      case ConnectionState.connectionFailed:
        setState(() => _state = ConnectionState.connecting);
        try {
          // ignore: body_might_complete_normally_catch_error
          final session = await connector.connect(context).catchError((error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error)));
          });

          if (session != null) {
            debugPrint("SESSION EXISTED");
            setState(() => _state = ConnectionState.connected);
            Future.delayed(Duration.zero, () => _openWalletPage());
          } else {
            // NOTE: workaround for `connect` working only once
            // see https://github.com/nextchapterstudio/walletconnect_qrcode_modal_dart/issues/22
            connector = EthereumTestConnector();
            setState(() => _state = ConnectionState.connectionCancelled);
          }
        } catch (e) {
          debugPrint('WC exception occured: $e');
          setState(() => _state = ConnectionState.connectionFailed);
        }
    }
  }

  // CHANGE IN NETWORK(CURRENTLY ONLY ETHEREUM NETWORK)
  void _changeNetwork(String? network) {
    if (network == null || _networkName == network) return;

    final index = _networks.indexOf(network);
    // update connector
    switch (index) {
      case 0:
        connector = EthereumTestConnector();
        break;
      default:
        connector = EthereumTestConnector();
        break;
    }

    // DISCONNECT NETWORK IF NETWORK CHANGE FOUND
    setState(
      () {
        _networkName = network;
        _state = ConnectionState.Disconnected;
      },
    );
  }
}
