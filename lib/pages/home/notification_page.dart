import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:intl/intl.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final GetController _getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    var notificationList = jsonDecode(_getController.loadNotificationMessages());
    print(notificationList);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        foregroundColor: AppColors.black,
        surfaceTintColor: AppColors.white,
        title: TextSmall(text: 'Bildirishnomalar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
      ),
      body: RefreshComponent(
          scrollController: _getController.scrollNotificationController,
          refreshController: _getController.refreshNotificationController,
          child: Column(
            children: [
              if (notificationList.isEmpty)
                Container(
                  width: Get.width,
                  height: Get.height * 0.8,
                  alignment: Alignment.center,
                  child: TextSmall(text: 'Bildirishnomalar mavjud emas'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                ),
              for (var notification in notificationList)
                Container(
                    width: Get.width,
                    margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
                    padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                    decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextSmall(text: DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(notification['date'])), color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                        SizedBox(height: 5.r),
                        TextSmall(text: notification['title'], color: AppColors.black, fontWeight: FontWeight.w500, maxLines: 3),
                        TextSmall(text: notification['body'], color: AppColors.black70.withOpacity(0.7), fontWeight: FontWeight.w500,maxLines: 300)
                      ]
                    )
                )
            ]
          )
      )
    );
  }
}