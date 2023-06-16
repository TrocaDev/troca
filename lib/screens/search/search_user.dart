// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:troca/screens/search/search_result.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:http/http.dart' as http;
import 'dart:convert';

//MOCK API

Future<Map<String, dynamic>> checkPhoneNumber(String phoneNumber) async {
  var headersList = {'Content-Type': 'application/json'};
  var url = Uri.parse('https://troca-backend.onrender.com/check');
  var body = {"handle": "$phoneNumber"};

  var req = http.Request('GET', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var response = await req.send();
  final resBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    return jsonDecode(resBody);
  } else if (response.statusCode == 400) {
    return jsonDecode(resBody);
  } else {
    throw Exception('Failed to check phone number');
  }
}

Future<String> findPhoneNumber(String phoneNumber) async {
  try {
    print("checking phone number");
    final result = await checkPhoneNumber(phoneNumber);

    // Handle the result based on the response body
    if (result.containsKey('connectedAddress')) {
      final connectedAddress = result['connectedAddress'];
      print('Connected Address: $connectedAddress');
      return connectedAddress;
    } else if (result.containsKey('message')) {
      final message = result['message'];
      print('Message: $message');
      return message;
    } else {
      print(result.toString());
      return "NAN";
    }
  } catch (e) {
    print('Error: $e');
  }
  return "NAN";
}

//UI
class SearchUser extends StatefulWidget {
  static const routeName = "/search-user";
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
    //Checking if provided string is ehtereum address
    if (isValidEthereumAddress(address) == true) {
      //checking if you can message the address
      bool _temp = await widget.client.canMessage(address);
      if (_temp == true) {
        ethadd = address;
      }
    }
    //check for phone number
    else {
      var phoneNumber = address;
      address = await findPhoneNumber(phoneNumber);
      //Process if phone number is valid
      if (isValidEthereumAddress(address) == true) {
        //checking if you can message the address
        bool _temp = await widget.client.canMessage(address);
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
    Navigator.of(context).pushNamed(
      SearchResult.routeName,
      arguments: [ethadd, widget.client],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SEARCH BAR
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
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
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
            child: ElevatedButton(
              onPressed: () async {
                _isTrue(_searchController.text);
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    color: Colors.red[400],
                  ),
                  Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
