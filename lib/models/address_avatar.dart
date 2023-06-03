import 'package:blockies_ethereum/blockie_widget.dart';
import 'package:blockies_ethereum/blockies_ethereum.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class AddressAvatar extends StatelessWidget {
  final EthereumAddress? address;

  AddressAvatar({Key? key, this.address})
      : super(key: Key(address?.hexEip55 ?? ""));

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: BlockieWidget(
        data: address?.hexEip55 ?? "",
        size: 0.75,
        shape: BlockiesShape.circle,
      ),
    );
  }
}
