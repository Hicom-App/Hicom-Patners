import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../filds/text_field_custom.dart';
import '../filds/text_small.dart';

class TransferWalletSkeleton extends StatelessWidget {
  const TransferWalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer(child: Column(
      children: [
        Container(width: Get.width, margin: EdgeInsets.only(left: 20.w, right: 20.w), child: TextSmall(text: 'To`lovga tasdiqlangan'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
        Container(
            width: Get.width,
            margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 11.h),
            padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h, bottom: 5.h),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
            child: Row(
                children: [
                  Icon(EneftyIcons.card_bold, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: 35.sp),
                  SizedBox(width: 10.w),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextSmall(text: 'Tasdiqlangan keshbek'.tr, color: AppColors.black, fontSize: 11.sp, fontWeight: FontWeight.w500),
                        Row(
                            children: [
                              TextSmall(text: '125 835', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 21.sp),
                              TextSmall(text: ' so`m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                            ]
                        )
                      ]
                  )
                ]
            )
        ),
        SizedBox(height: 35.h),
        Container(width: Get.width, margin: EdgeInsets.only(left: 15.w, right: 15.w), child: TextSmall(text: 'Mening kartalarim'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 15.sp)),
        Container(
            width: Get.width,
            margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 8.h,),
            padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10.h, bottom: 10.h),
            decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.grey),
                boxShadow: [BoxShadow(color: AppColors.black70.withOpacity(0.1), blurRadius: 25.r, spreadRadius: 25.r, offset: const Offset(0, 1))],
                image: DecorationImage(image: Image.asset('assets/images/card_fon.png').image, fit: BoxFit.cover)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50.h,
                      width: 50.w,
                      margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                      child: SvgPicture.asset('assets/svg_assets/uz_card.svg', colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn), fit: BoxFit.contain)
                  ),
                  TextSmall(text: '9860 3501 0156 4282', color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                  TextSmall(text: 'Dilshodjon Haydarov', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                  SizedBox(height: 4.h)
                ]
            )
        ),
        Container(
            width: Get.width,
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h,),
            padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10.h, bottom: 10.h),
            decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [BoxShadow(color: AppColors.black70.withOpacity(0.1), blurRadius: 25.r, spreadRadius: 25.r, offset: const Offset(0, 1))],
                image: DecorationImage(image: Image.asset('assets/images/card_fon.png').image, fit: BoxFit.cover)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50.h,
                      width: 50.w,
                      margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                      child: SvgPicture.asset('assets/svg_assets/uz_card.svg', colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn), fit: BoxFit.contain)
                  ),
                  TextSmall(text: '9860 3501 0156 4282', color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                  TextSmall(text: 'Dilshodjon Haydarov', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                  SizedBox(height: 4.h)
                ]
            )
        ),
        Container(
            width: Get.width,
            margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 10.h),
            child: TextSmall(text: 'To`lov summasi'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
        ),
        TextFieldCustom(fillColor: AppColors.white, hint: '828', controller: GetController().cardNumberController),
        SizedBox(height: Get.height * 0.025),
        Container(
            margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), minimumSize: Size(Get.width, 50.h)),
                onPressed: (){},
                child: TextSmall(text: 'Jo‘natish'.tr, color: AppColors.white, fontWeight: FontWeight.w500)
            )
        )
      ]
  ));
}