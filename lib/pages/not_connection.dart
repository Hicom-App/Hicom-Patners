import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import '../resource/colors.dart';

class NotConnection extends StatelessWidget{
  const NotConnection({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_off, color: AppColors.red, size: 100.sp),
                SizedBox(height: 20.h),
                Text('Internet mavjud emas'.tr, style: TextStyle(fontSize: 16.sp, color: AppColors.black)),
                SizedBox(height: 20.h,width: Get.width),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r))),
                    onPressed: () {
                      Get.offAll(() => SplashScreen());
                      //_getController.logout();
                    },
                    child: Text('Qayta urinish'.tr, style: TextStyle(fontSize: 16.sp, color: AppColors.white))
                )
              ]
          )
      );
}