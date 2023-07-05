import 'package:dotenv/dotenv.dart' as env;
import 'package:ens_dart/ens_dart.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:troca/routes/app_route_constants.dart';
import 'package:troca/screens/search/search_user.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../../session/foreground_session.dart';

class DM extends StatefulWidget {
  DM({super.key, required this.ethereum});
  final String ethereum;

  @override
  State<DM> createState() => _DMState();
}

class _DMState extends State<DM> {
  //init
  @override

  //variables
  // bool _isLoading = true;

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Column(
            children: [
              const Text("Start a conversation with "),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.ethereum,
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
                    var _boolean = await _isTrue(widget.ethereum);
                    if (_boolean == true) {
                      startConversation(widget.ethereum);
                    } else {
                      GoRouter.of(context)
                          .pushNamed(TrocaRouteConstants.loginRoute);
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

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  void startConversation(String Ethaddress) async {
    var mySecureStorage = const FlutterSecureStorage();
    var conversationId = await mySecureStorage.read(key: Ethaddress);
    if (conversationId != null && conversationId.isNotEmpty) {
      var convo = await session.newConversation(Ethaddress,
          conversationId: conversationId);
      var conversation = await session.findConversation(convo);

      GoRouter.of(context).pushReplacementNamed(
        TrocaRouteConstants.testChatScreenRoute,
        extra: conversation,
      );
    } else {
      var convo = await session.newConversation(Ethaddress);
      var conversation = await session.findConversation(convo);

      GoRouter.of(context).pushReplacementNamed(
        TrocaRouteConstants.testChatScreenRoute,
        extra: conversation,
      );
    }
  }

  void runFunction(String address) {
    _isTrue(address);
  }

  Future<bool> _isTrue(String address) async {
    String ethadd = "";
    print("1");
    //Checking if provided string is ehtereum address
    if (isValidEthereumAddress(address) == true) {
      print("2");

      //checking if you can message the address

      try {
        bool _temp = await session.canMessage(address);
        if (_temp == true) {
          print("4");
          ethadd = address;
        }
      } catch (e) {
        print(e);
      }
      print("3");

      print("5");
    }
    //check for phone number
    else if (address.startsWith('+')) {
      var phoneNumber = address;
      address = await findPhoneNumber(phoneNumber);
      //Process if phone number is valid
      if (isValidEthereumAddress(address) == true) {
        //checking if you can message the address
        bool _temp = await session.canMessage(address);
        if (_temp == true) {
          ethadd = address;
        }
      }
      //Process if phone number isn't valid
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Not a valid Input")));
      }
    }
    //Checking for ens domains
    else {
      print("checking ens domain");
      env.load('../.env');
      // ignore: unused_local_variable
      final infuraKey = env.env['ea95c129edfd4d2990138f7ec98619f6'];

      const rpcUrl =
          'https://mainnet.infura.io/v3/ea95c129edfd4d2990138f7ec98619f6';
      const wsUrl =
          'wss://mainnet.infura.io/ws/v3/ea95c129edfd4d2990138f7ec98619f6';

      final client = Web3Client(rpcUrl, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(wsUrl).cast<String>();
      });

      final ens = Ens(client: client);

      var x = await ens.withName(address).getAddress();
      print(x.toString());
      if (x.toString() != "0x0000000000000000000000000000000000000000") {
        ethadd = x.toString();
        print(ethadd);
      }
    }
    print("6");

    if (ethadd == "")
      return false;
    else
      return true;
  }
}
