import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';

import '../../controllers/get_controller.dart';
import '../auth/login_page.dart';
import '../onboarding.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final GetController _getController = Get.put(GetController());

  void open() {
    Get.offAll(() => SamplePage(), transition: Transition.fadeIn);
    //Get.offAll(() => LoginPage(), transition: Transition.fadeIn);
    //Get.offAll(() => OnBoarding(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    _getController.tapTimes(open,1);

    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: Container()),
                  SizedBox(width: Get.width * 0.7, child: Image.asset(Theme.of(context).brightness == Brightness.light ? 'assets/images/logo.png' : 'assets/images/logo_night.png', fit: BoxFit.cover)),
                  Flexible(child: Container()),
                  CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                  SizedBox(height: Get.height * 0.04),
                  Text('${'Talqin'.tr}: 1.0.0', style: TextStyle(fontSize: Get.width * 0.035, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: Get.height * 0.02),
                ]
            )
        )
    );
  }
}
