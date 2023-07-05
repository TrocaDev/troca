import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:troca/screens/qr_code/qr_scanner.dart';
import 'package:troca/session/foreground_session.dart';

class QRCode extends StatelessWidget {
  const QRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 247, 247, 247),
                ),
                padding: const EdgeInsets.all(20),
                width: 200,
                height: 200,
                child: QrImageView(
                  data: session.me.toString(),
                  size: 320,
                  gapless: true,
                  version: QrVersions.auto,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Here is your QR Code!",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Scan this QR Code to start a conversation with me."),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.qr_code_scanner_outlined),
        style: ButtonStyle(
          iconColor: MaterialStateProperty.all(Colors.black),
          iconSize: MaterialStateProperty.all(75),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
