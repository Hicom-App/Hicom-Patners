import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_large.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextLarge(text: 'Detail'.tr),
      )
    );
  }
}