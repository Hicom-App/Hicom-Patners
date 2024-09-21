import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kartaga o`tkazmalar'.tr),
        ),
        body: Obx(() => Column(
          children: [
            SizedBox(height: 20.h),
            Container(
                width: Get.width,
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                child: TextSmall(text: 'Karta ma`lumotlari'.tr, color: AppColors.black, fontWeight: FontWeight.w500)
            ),
            Container(
                width: Get.width,
                margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,bottom: 20.h),
                padding: EdgeInsets.only(left: 25.w, right: 20.w, top: 10.h, bottom: 10.h),
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[_getController.cardBackIndex.value]), fit: BoxFit.cover)
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.01),
                      TextSmall(text: 'Karta nomi'.tr, color: AppColors.white, fontWeight: FontWeight.w500),
                      Container(
                          margin: EdgeInsets.only(top: Get.height * 0.02, right: Get.width * 0.15,bottom: Get.height * 0.01),
                          height: Get.height * 0.05,
                          padding: EdgeInsets.only(right: Get.width * 0.01,left: Get.width * 0.03),
                          decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(20.r)),
                          child: TextField(
                              controller: _getController.searchController,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                  hintText: 'F.I.O',
                                  hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: Get.width * 0.04),
                                  border: InputBorder.none
                              )
                          )
                      ),
                      TextSmall(text: 'Karta raqami'.tr, color: AppColors.white, fontWeight: FontWeight.w500),
                      Container(
                          margin: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.02),
                          height: Get.height * 0.05,
                          padding: EdgeInsets.only(right: Get.width * 0.01,left: Get.width * 0.03),
                          decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(20.r)),
                          child: TextField(
                              controller: _getController.searchController,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                  hintText: '0000 0000 0000 0000',
                                  hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: Get.width * 0.04),
                                  border: InputBorder.none
                              )
                          )
                      ),
                    ]
                )
            ),
            SizedBox(
                height: 50.h,
                width: Get.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _getController.listCardBackImage.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () => _getController.changeCardBackIndex(index),
                        child: Container(
                            width: 50.w,
                            height: 50.h,
                            margin: EdgeInsets.only(left: 10.w),
                            decoration: BoxDecoration(
                                color: AppColors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(200.r),
                                image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[index]), fit: BoxFit.cover)
                            )
                        )
                    )
                )
            ),
            Container(
                width: Get.width,
                margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,),
                padding: EdgeInsets.only(left: 25.w, right: 20.w, top: 10.h, bottom: 10.h),
                decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(EneftyIcons.info_circle_bold, color: AppColors.red, size: 25.h),
                    SizedBox(width: 20.w),
                    SizedBox(
                        width: Get.width * 0.7,
                        child: TextSmall(text: 'Ushbu sahifada +998995340313 raqamga biriktirilgan bank kartalarni qo\'shish mumkin. Agar boshqa bank kartasini qo\'shish kerak bo\'lsa, pastdagi telefon raqamini o\'zgartirish funksiyasidan foydalanish mumkin.'.tr,
                            color: AppColors.black, fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            maxLines: 200)
                    )
                  ],
                )
            ),
            const Spacer(),
            Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
                width: Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    backgroundColor: AppColors.blue,
                    padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  ),
                  onPressed: () => Get.back(),
                  child: TextSmall(text: 'Qo\'shish'.tr, color: AppColors.white),
                )
            ),
          ],
        ))
    );
  }
}