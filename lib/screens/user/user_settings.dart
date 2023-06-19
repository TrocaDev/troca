import 'package:flutter/material.dart';
import 'package:troca/screens/user/connect_mobile.dart';

class UserSettings extends StatelessWidget {
  static const routeName = "/user-settings";
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
          child: TextFormField(
            onFieldSubmitted: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.pink[50],
              hintText: "Ethereum address, Phone Number or Name",
              hintStyle: const TextStyle(color: Colors.pink),
              labelText: 'Search Settings',
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
        ListView(
          shrinkWrap: true,
          children: [
            //1 Connect Mobile Number
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ConnectMobile.routeName,
                  );
                },
                title: const Text("Connect Mobile Number"),
                leading: const Icon(Icons.mobile_friendly_rounded),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ConnectMobile.routeName,
                  );
                },
                title: const Text("Account Settings"),
                leading: const Icon(Icons.person_outline_outlined),
              ),
            )
          ],
        )
      ]),
    );
  }
}
