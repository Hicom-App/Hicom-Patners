import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'checks_detail.dart';

class ChecksPage extends StatelessWidget {
  ChecksPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        surfaceTintColor: AppColors.white,
        title: TextSmall(text: 'Mening cheklarim'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      body: Obx(() =>  RefreshComponent(
          scrollController: _getController.scrollChecksController,
          refreshController: _getController.refreshChecksController,
          child: Column(
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                    width: Get.width,
                    height: Get.height * 0.03,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getController.listMonth.length,
                      itemBuilder:(context, index) => GestureDetector(
                        onTap: () => _getController.changeSelectedMonth(index),
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 15.w),
                            padding: EdgeInsets.only(left: 10.w, right: 10.w,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: _getController.selectedMonth.value == index
                                  ? AppColors.blue // Selected color
                                  : AppColors.grey.withOpacity(0.1), // Default color
                            ),
                            child: TextSmall(text: _getController.listMonth[index], color: _getController.selectedMonth.value == index ? AppColors.white : AppColors.black, fontWeight: FontWeight.w500, maxLines: 1)
                        )
                      )
                    )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 10.h),
                    Container(
                        width: Get.width * 0.44,
                        margin: EdgeInsets.only(top: 15.h,),
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'Hisoblangan'.tr, color: AppColors.blue, fontWeight: FontWeight.w500, fontSize: 14.sp),
                              Row(
                                children: [
                                  TextSmall(text: '2 202.71'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                  SizedBox(width: 5.w),
                                  TextSmall(text: 'so`m'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                ]
                              ),
                              Row(
                                  children: [
                                    TextSmall(text: '14'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    SizedBox(width: 5.w),
                                    TextSmall(text: 'ta'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                  ]
                              )

                            ])
                    ),
                    Container(
                        width: Get.width * 0.44,
                        margin: EdgeInsets.only(top: 15.h),
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'Rad etilgan'.tr, color: AppColors.red, fontWeight: FontWeight.w500, fontSize: 14.sp),
                              Row(
                                children: [
                                  TextSmall(text: '0.00'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                  SizedBox(width: 5.w),
                                  TextSmall(text: 'so`m'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                ]
                              ),
                              Row(
                                  children: [
                                    TextSmall(text: '0'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    SizedBox(width: 5.w),
                                    TextSmall(text: 'ta'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                  ]
                              )

                            ])
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 10.h),
                    Container(
                        width: Get.width * 0.44,
                        margin: EdgeInsets.only(top: 15.h,),
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'Jarayonda'.tr, color: AppColors.primaryColor, fontWeight: FontWeight.w500, fontSize: 14.sp),
                              Row(
                                children: [
                                  TextSmall(text: '0.00'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                  SizedBox(width: 5.w),
                                  TextSmall(text: 'so`m'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                ]
                              ),
                              Row(
                                  children: [
                                    TextSmall(text: '14'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    SizedBox(width: 5.w),
                                    TextSmall(text: 'ta'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                  ]
                              )

                            ])
                    ),
                    Container(
                        width: Get.width * 0.44,
                        margin: EdgeInsets.only(top: 15.h),
                        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20.r))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'To`langan'.tr, color: AppColors.green, fontWeight: FontWeight.w500, fontSize: 14.sp),
                              Row(
                                children: [
                                  TextSmall(text: '10000.01'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                  SizedBox(width: 5.w),
                                  TextSmall(text: 'so`m'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                ]
                              ),
                              Row(
                                  children: [
                                    TextSmall(text: '1'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    SizedBox(width: 5.w),
                                    TextSmall(text: 'ta'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp),
                                  ]
                              )

                            ])
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
                SizedBox(height: 30.h),
                SizedBox(
                    width: Get.width,
                    child: ListView.builder(
                        itemCount: _getController.listImagePrice.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) => GestureDetector(
                          onTap: () => Get.to(() => ChecksDetail(), arguments: _getController.listImagePrice[index]),
                          child: Column(
                              children: [
                                index == 0 || index == 2 || index == 3 || index == 6 || index == 13? Container(
                                  margin: EdgeInsets.only(top: Get.width * 0.02),
                                  padding: EdgeInsets.only(left: Get.width * 0.015, right: Get.width * 0.015),
                                  child: TextSmall(text:
                                  index == 0 ? 'Bugun'
                                      : index == 2 ? 'Kecha'
                                      : index == 3 ? '15 Sentabr'
                                      : index == 6 ? '10 Sentabr'
                                      : '5 Sentabr',
                                      color: AppColors.black.withOpacity(0.6), fontWeight: FontWeight.w400),
                                ) : Container(),
                                Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                                    padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: AppColors.grey.withOpacity(0.1)
                                    ),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10.w),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                index == 0 ? TextSmall(text: 'Bank kartalari',
                                                    color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 13.sp) : index == 1 ? TextSmall(text: 'Keshbek', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 13.sp): index == 2 ? TextSmall(text: 'Bank Kartalari', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 13.sp):TextSmall(text: 'Keshbek', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 13.sp),
                                                index == 0 ? TextSmall(text: _getController.listNames[index], color: AppColors.black, fontWeight: FontWeight.w500)
                                                    :index == 2 ? TextSmall(text: _getController.listNames[index], color: AppColors.black, fontWeight: FontWeight.w500):  const TextSmall(text: 'Balansni to`ldirish', color: AppColors.black, fontWeight: FontWeight.w500)
                                              ]
                                          ),
                                          const Spacer(),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                    children: [
                                                      TextSmall(text: _getController.listNamesPay[index], color: _getController.listNamesPay[index].contains('-') ? AppColors.red : AppColors.black, fontWeight: FontWeight.w500),
                                                      TextSmall(text: '.00'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 12.sp),
                                                      SizedBox(width: 5.w),
                                                      TextSmall(text: 'So`m'.tr, color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 12.sp)
                                                    ]
                                                ),
                                                Row(
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(top: 3.h,right: 5.w),
                                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 3.h, bottom: 3.h),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(50.r),
                                                              color: index == 0 ? AppColors.green : index == 1 ? AppColors.red : index == 2 ? AppColors.primaryColor : AppColors.blue
                                                          ),
                                                          child: TextSmall(
                                                              text: index == 0 ? 'To`landi'.tr : index == 1 ? 'Rad etildi'.tr : index == 2 ? 'Jarayonda'.tr : 'Qabul qilindi'.tr,
                                                              color: AppColors.white,
                                                              fontWeight: FontWeight.w400, fontSize: 11.sp)
                                                      ),
                                                      TextSmall(text: _getController.listNamesDay[index], color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 14.sp)
                                                    ]
                                                )
                                              ]
                                          )
                                        ]
                                    )
                                )
                              ]
                          )
                        )
                    )
                )
              ]
          )
      )
    ));
  }
}