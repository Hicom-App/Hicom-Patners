import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import '../../resource/colors.dart';

class ChecksDetail extends StatelessWidget{
  const ChecksDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
          onPressed: () {
            Get.back();
          }
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
            onPressed: () {}
          )
        ]
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.check_circle, color: Colors.green, size: 80.sp),
            SizedBox(height: 10.h),
            TextSmall(text: 'Muvaffaqiyatli o‘tkazildi',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
            SizedBox(height: 5.h),
            TextSmall(text: 'Yak, 6 Iyun 2022',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).brightness == Brightness.light ? AppColors.greys : AppColors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSmall(text: 'Tranzaksiya tafsilotlari',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'To‘lov usuli',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white),
                          SizedBox(width: 5.h),
                          TextSmall(text: '**** **** **** 4204',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                        ]
                      ),
                    ]
                  ),
                  SizedBox(height: 5.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSmall(text: 'Buyurtmachi',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                        TextSmall(text: 'abd***** ****bek',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                      ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'To‘langan vaqti', fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '11:27',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Tranzaksiya raqami',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '#21120839289',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Jami',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                      TextSmall(text: '10 000.00',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                    ]
                  )
                ]
              )
            ),
            SizedBox(height: 20.h),
            Container(
                width: Get.width,
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextSmall(text: 'Qo`shimcha',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                            SizedBox(height: 10.h),
                            TextSmall(text: 'Iltimos hisobingizni tekshirib ko`ring.\nbu vaqt olishi mumkin edi\nagar tushmagan bo`lsa biroz kuting',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, maxLines: 10),
                          ]
                      ),
                    ]
                )
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), backgroundColor: AppColors.blue, padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 15.h)),
              child: TextSmall(text: 'Orqaga', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1,fontSize: 16.sp)
            ),
            SizedBox(height: 30.h)
          ]
        )
      )
    );
  }
}