import 'package:flutter/material.dart';
import 'package:troca/screens/search/search_result.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

//MOCK API
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadJsonData() async {
  final jsonString = await rootBundle.loadString('lib/assets/json/mobile.json');
  final jsonData = json.decode(jsonString);
  return jsonData;
}

Future<String> fetchNameFromPhoneNumber(String phoneNumber) async {
  final jsonData = await loadJsonData();
  final phoneNumbers = jsonData['phoneNumbers'];

  for (final data in phoneNumbers) {
    if (data['number'] == phoneNumber) {
      return data['name'];
    }
  }

  return 'Name not found';
}

//UI
class SearchUser extends StatefulWidget {
  const SearchUser({super.key, required this.client});

  final xmtp.Client client;

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  //Variables
  TextEditingController _searchController = TextEditingController();

  Future<void> _isTrue(String address) async {
    String ethadd = "";
    //Checking if ethereum address is valid
    if (isValidEthereumAddress(address) == true) {
      //checking if you can message the address
      bool _temp = await widget.client.canMessage(address);
      if (_temp == true) {
        ethadd = address;
      }
    } else {
      //check for name and number
      final fetchedName = await fetchNameFromPhoneNumber(address);
      if (fetchedName != "Name not found") {
        ethadd = fetchedName;
      }
    }
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResult(
          ethereum: ethadd,
          client: widget.client,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //SEARCH BAR
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: TextFormField(
              controller: _searchController,
              onFieldSubmitted: _isTrue,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.pink[50],
                hintText: "Ethereum address, Phone Number or Name",
                hintStyle: const TextStyle(color: Colors.pink),
                labelText: 'Search User',
                labelStyle: const TextStyle(color: Colors.pink),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.pink,
                ),
              ),
            ),
          ),

          //RESULT
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
            child: ElevatedButton(
              onPressed: () async {
                _isTrue(_searchController.text);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person_search_outlined),
                  Text("Search"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
