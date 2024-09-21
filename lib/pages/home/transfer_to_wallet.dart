import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferToWallet extends StatelessWidget {
  final int index;
  const TransferToWallet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hisobga olish'.tr),
      ),
      body: Center(
        child: Text('Hisobga olish'.tr),
      ),
    );
  }
}