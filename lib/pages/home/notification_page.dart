import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/resource/colors.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final GetController _getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
        surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        title: TextSmall(text: 'Bildirishnoma'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
      ),
      body: RefreshComponent(
          scrollController: _getController.scrollNotificationController,
          refreshController: _getController.refreshNotificationController,
          child: Column(
            children: [
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  decoration: BoxDecoration(color: AppColors.greys.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextSmall(text: '12.03.2024 13:32'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 14.sp),
                      SizedBox(height: 5.r),
                      TextSmall(text: 'Hicomda aksiya boshlandi!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
                      TextSmall(text: 'Hurmatli mijozlar! Sizni mamnuniyat bilan xabardor qilamizki, do‘konimizda maxsus aksiya boshlandi. Chegirmalar va maxsus takliflardan foydalanish imkoniyatini boy bermang!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white.withOpacity(0.7), fontWeight: FontWeight.w400,maxLines: 300),
                    ],
                  )
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextSmall(text: '12.03.2024  11:12'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 14.sp),
                      SizedBox(height: 5.r),
                      TextSmall(text: 'Hicomda aksiya boshlandi!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
                      TextSmall(text: 'Hurmatli mijozlar! Sizni mamnuniyat bilan xabardor qilamizki, do‘konimizda maxsus aksiya boshlandi. Chegirmalar va maxsus takliflardan foydalanish imkoniyatini boy bermang!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white.withOpacity(0.7), fontWeight: FontWeight.w500,maxLines: 300),
                    ],
                  )
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextSmall(text: '12.03.2024 22:31'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 14.sp),
                      SizedBox(height: 10.r),
                      SizedBox(
                        width: Get.width,
                        height: Get.height *0.25,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20.r)),
                            child: FadeInImage(
                                image: NetworkImage(_getController.listImage[2]),
                                placeholder:NetworkImage(_getController.listImage[2]),
                                imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://img.icons8.com/?size=100&id=91076&format=png&color=000000'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(20.r))));},
                                fit: BoxFit.cover
                            )
                        )
                      ),
                      SizedBox(height: 10.r),
                      TextSmall(text: 'Hicomda aksiya boshlandi!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
                      TextSmall(text: 'Hurmatli mijozlar! Sizni mamnuniyat bilan xabardor qilamizki, do‘konimizda maxsus aksiya boshlandi. Chegirmalar va maxsus takliflardan foydalanish imkoniyatini boy bermang!'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white.withOpacity(0.7), fontWeight: FontWeight.w500,maxLines: 300)
                    ]
                  )
              )
            ]
          )
      )
    );
  }
}