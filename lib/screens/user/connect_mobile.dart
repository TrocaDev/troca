import 'package:flutter/material.dart';

class ConnectMobile extends StatelessWidget {
  static const routeName = "/connect-mobile";
  const ConnectMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        //Text Field
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.pink[50],
              labelText: 'Enter Mobile Number',
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
        // Button
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          child: ElevatedButton(
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.person_search_outlined),
                Text("Search"),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
