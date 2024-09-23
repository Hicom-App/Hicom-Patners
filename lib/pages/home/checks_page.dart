import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';

import '../../resource/colors.dart';

class ChecksPage extends StatelessWidget {
  const ChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        surfaceTintColor: AppColors.white,
        title: TextSmall(text: 'Mening cheklarim'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      body: Container(),
    );
  }

}