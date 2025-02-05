import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../auth/language_page.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final GetController _getController = Get.put(GetController());

  Future<void> open() async {
    debugPrint('${_getController.token} ${_getController.phoneNumber}');
    if (_getController.token != null && _getController.token!.isNotEmpty || _getController.phoneNumber != null && _getController.phoneNumber!.isNotEmpty) {
      ApiController().getProfile();
    } else {
      Get.offAll(() => const LanguagePage(), transition: Transition.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    ApiController().postFcmToken();
    _getController.tapTimes(open,1);
    return Scaffold(
      body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/splash_fon.png'), fit: BoxFit.cover)),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Container()),
                    SizedBox(height: Get.height * 0.07),
                    Flexible(child: Container()),
                    CupertinoActivityIndicator(radius: 20.sp, color: AppColors.white),
                    SizedBox(height: Get.height * 0.04),
                    TextSmall(text: '${'Ilova versiyasi'.tr} ${_getController.version.value}', color: AppColors.white, fontSize: 12.sp),
                    SizedBox(height: Get.height * 0.03)
                  ]
              )
          )
      )
    );
  }
}
