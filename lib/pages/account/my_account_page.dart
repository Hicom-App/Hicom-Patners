import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_small.dart';
import '../../resource/colors.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: 'Mening hisobim'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
        body: Column(
          children: [

          ],
        )
    );
  }
}