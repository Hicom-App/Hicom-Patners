import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class TransferToWallet extends StatelessWidget {
  final int index;
  TransferToWallet({super.key, required this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kartaga o`tkazmalar'.tr),
      ),
      body: RefreshComponent(
        refreshController: _getController.refreshTransferWalletController,
        scrollController: _getController.scrollTransferWalletController,
        child: Column(
          children: [
            Container(
              width: Get.width,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r)
              ),
              child: Row(
                children: [
                  Icon(EneftyIcons.money_3_bold, color: AppColors.blue, size: 40.sp),
                  SizedBox(width: 10.w),
                  Column(
                    children: [
                      TextSmall(text: 'Tug`ilgan sanasi'.tr, color: AppColors.white, fontWeight: FontWeight.w500),
                      TextLarge(text: '15.02.2022', color: AppColors.white, fontWeight: FontWeight.w500)
                    ],
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}