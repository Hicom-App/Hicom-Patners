import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_small.dart';
import '../../resource/colors.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: 'Sevimli tovarlar'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
        body: Column(
          children: [

          ],
        )
    );
  }

}