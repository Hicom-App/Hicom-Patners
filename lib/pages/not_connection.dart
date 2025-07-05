import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import '../companents/filds/text_small.dart';
import '../resource/colors.dart';

class NotConnection extends StatelessWidget {
  const NotConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Yumshoq oq fon
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pulsatsiya animatsiyasi bilan ikonka
            AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.wifi_off_rounded, // Zamonaviyroq ikonka
                color: AppColors.red.withOpacity(0.8),
                size: 120.sp,
              ),
            ),
            SizedBox(height: 30.h),
            // Matnni Schyler shrifti bilan
            Text(
              'Internet mavjud emas'.tr,
              style: TextStyle(
                fontFamily: 'Schyler',
                color: AppColors.black.withOpacity(0.85),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            // Qo'shimcha izoh matni
            Text(
              'Iltimos, internet aloqangizni tekshiring'.tr,
              style: TextStyle(
                fontFamily: 'Schyler',
                color: AppColors.black70,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Zamonaviy gradientli tugma
            GestureDetector(
              onTap: () {
                Get.offAll(() => SplashScreen());
              },
              child: Container(
                width: 200.w,
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.red, AppColors.red.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Qayta urinish'.tr,
                    style: TextStyle(
                      fontFamily: 'Schyler',
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}