import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final GetController _getController = Get.put(GetController());

  void open() {
    //Get.offAll(() => SamplePage(), transition: Transition.fadeIn);
    Get.offAll(() => LoginPage(), transition: Transition.fadeIn);
    //Get.offAll(() => OnBoarding(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    _getController.tapTimes(open,5);
    return Scaffold(
      body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover)),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Container()),
                    SizedBox(height: Get.height * 0.07),
                    SizedBox(width: Get.width * 0.43, child: SvgPicture.asset('assets/svg_assets/logo.svg', color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.white, fit: BoxFit.contain)),
                    Flexible(child: Container()),
                    CupertinoActivityIndicator(radius: Get.width * 0.05, color: AppColors.white),
                    SizedBox(height: Get.height * 0.04),
                    Text('${'Version'.tr}: 1.0.0', style: TextStyle(fontSize: Get.width * 0.035, fontWeight: FontWeight.w500, color: AppColors.white)),
                    SizedBox(height: Get.height * 0.03)
                  ]
              )
          )
      )
    );
  }
}
