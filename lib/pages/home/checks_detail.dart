import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';

import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class ChecksDetail extends StatelessWidget{
  ChecksDetail({super.key});

  final GetController _getController = Get.put(GetController());
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
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 10),
            TextSmall(text: 'Muvaffaqiyatli o‘tkazildi',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
            SizedBox(height: 5.h),
            TextSmall(text: 'Yak, 6 Iyun 2022',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                //color: Colors.grey[200],
                color: AppColors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSmall(text: 'Booking Fee',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                      SizedBox(height: 8.h),
                      TextSmall(text: 'Treatment name',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: 'Braces Application',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                      SizedBox(height: 4.h),
                      TextSmall(text: 'Clinic name',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: 'Avicena Clinic',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                    ]
                  ),
                  const Spacer(),
                  TextSmall(text: '10 000.00',fontSize: 20.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                  SizedBox(width: 5.h),
                  TextSmall(text: 'so`m',fontSize: 15.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                ]
              )
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                //color: Colors.white,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    //color: Colors.grey.withOpacity(0.2),
                    color: Theme.of(context).brightness == Brightness.light ? AppColors.greys : AppColors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Transaction detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextSmall(text: 'Transaction detail',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Bill ID',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '#BILL00124',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Reservation ID',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '#RSVA0011',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Payment Method',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white),
                          SizedBox(width: 5.h),
                          TextSmall(text: '**** **** **** 4204',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                        ]
                      )
                    ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Booking fee',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '10 000.00',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Tax',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: '\$0.00',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Total',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                      TextSmall(text: '10 000.00',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                    ]
                  )
                ]
              )
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), backgroundColor: AppColors.blue, padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 15.h)),
              child: TextSmall(text: 'Bosh sahifa', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1,fontSize: 16.sp)),
            SizedBox(height: 30.h)
          ]
        )
      )
    );
  }
}