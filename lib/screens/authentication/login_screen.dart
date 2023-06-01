import 'package:flutter/material.dart';

import '../../models/ethereum_connecter.dart';
import '../../models/test_connecter.dart';

enum ConnectionState {
  Disconnected,
  connecting,
  connected,
  connectionFailed,
  connectionCancelled,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //TEST CONNECTERS
  TestConnector connector = EthereumTestConnector();

  //Connecting Networks
  static const _networks = ['Ethereum (Ropsten)'];

  //Initial conditions
  ConnectionState _state = ConnectionState.Disconnected;
  String? _networkName = _networks.first;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed:
                        _transactionStateToAction(context, state: _state),
                    // const AuthScreen().createClient(context)
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8859EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      minimumSize:
                          Size(0.9 * MediaQuery.of(context).size.width, 0),
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
    );
  }

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

  void _openWalletPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Scaffold(
            body: Center(
          child: Text("WALLET CONNECTED"),
        )),
      ),
    );
  }

  VoidCallback? _transactionStateToAction(BuildContext context,
      {required ConnectionState state}) {
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
        return () async {
          setState(() => _state = ConnectionState.connecting);
          try {
            final session =
                await connector.connect(context).catchError((error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
              return null;
            });

            if (session != null) {
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
        };
    }
  }

  void _changeNetwork(String? network) {
    if (network == null || _networkName == network) return;

    final index = _networks.indexOf(network);
    // update connector
    switch (index) {
      case 0:
        connector = EthereumTestConnector();
        break;
      case 1:
        connector = EthereumTestConnector();
        break;
    }

    setState(
      () {
        _networkName = network;
        _state = ConnectionState.Disconnected;
      },
    );
  }
}
