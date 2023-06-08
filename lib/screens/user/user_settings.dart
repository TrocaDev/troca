import 'package:flutter/material.dart';
import 'package:troca/screens/user/connect_mobile.dart';

class UserSettings extends StatelessWidget {
  static const routeName = "/user-settings";
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              tileColor: Colors.pink[50],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectMobile(),
                  ),
                );
              },
              title: Text("Connect Mobile Number"),
            )
          ],
        )
      ]),
    );
  }
}
