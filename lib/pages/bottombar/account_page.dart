import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_large.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextLarge(text: 'Account'.tr),
      )
    );
  }
}