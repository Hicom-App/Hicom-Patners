
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:pinput/pinput.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../sample/sample_page.dart';

class VerifyPageNumber extends StatefulWidget {
  const VerifyPageNumber({super.key});

  @override
  _VerifyPageNumberState createState() => _VerifyPageNumberState();
}

class _VerifyPageNumberState extends State<VerifyPageNumber> {
  final GetController _getController = Get.put(GetController());
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;
  bool animateTextFields = false;

  @override
  void initState() {
    super.initState();
    _startDelayedAnimation();
  }

  void _startDelayedAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        animateTextFields = true;
      });
    });
    animateTextFields = false;
  }

  @override
  Widget build(BuildContext context) {
    _getController.startTimer();
    final defaultPinTheme = PinTheme(
      width: Theme.of(context).textTheme.headlineLarge!.fontSize! * 1.4,
      height: Theme.of(context).textTheme.headlineLarge!.fontSize! * 1.6,
      textStyle: Theme.of(context).textTheme.headlineSmall,
      decoration: BoxDecoration(
          border: Theme.of(context).colorScheme.onSurface.withOpacity(0.1).value == 0
              ? Border.all(color: AppColors.grey.withOpacity(0.1), width: 1)
              : Border.all(color: AppColors.grey.withOpacity(0.1)),
          color: AppColors.grey.withOpacity(0.1),
          borderRadius:BorderRadius.circular(10.r)
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(border: Border.all(color: AppColors.blue), color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r));
    final submittedPinTheme = defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration?.copyWith(color: AppColors.grey.withOpacity(0.1)));
    final errorPinTheme = defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration?.copyWith(color: AppColors.red.withOpacity(0.1), border: Border.all(color: AppColors.red), borderRadius: BorderRadius.circular(10.r)));
    final successPinTheme = defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration?.copyWith(color: AppColors.green.withOpacity(0.1), border: Border.all(color: AppColors.green), borderRadius: BorderRadius.circular(10.r)));
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (!isKeyboardVisible) _startDelayedAnimation();

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is UserScrollNotification) {
                    FocusScope.of(context).unfocus();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                    child: Container(
                        width: Get.width,
                        height: Get.height,
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fon.png'), fit: BoxFit.fitWidth)),
                        child: Stack(
                            children: [
                              Positioned.fill(child: Image.asset('assets/images/fon.png', fit: BoxFit.fitWidth)),
                              Positioned(
                                  top: 0,
                                  child: AnimatedContainer(
                                      width: Get.width,
                                      //height: isKeyboardVisible ? 200.h : 380.h,
                                      height: isKeyboardVisible ? Get.height * 0.22 : Get.height * 0.4,
                                      duration: const Duration(milliseconds: 500), // Biroz ko'proq vaqt
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))])
                                  )
                              ),
                              Positioned(top: Get.height * 0.05, left: 0, child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_rounded, color: AppColors.white, size: 45.sp))),
                              Positioned.fill(
                                  child: Column(
                                      children: [
                                        SizedBox(height: Get.height * 0.3),
                                        AnimatedSlide(
                                            offset: animateTextFields ? const Offset(0, 0.0) : const Offset(0, 0.8),
                                            duration: Duration(milliseconds: animateTextFields ? 550 : 400),
                                            curve: Curves.easeInOut, // Uyg'un ravishda
                                            child: Column(
                                                children: [
                                                  Container(
                                                      width: Get.width,
                                                      margin: EdgeInsets.only(left: 25.w, right: 25.w),
                                                      child: TextLarge(text: '${'Kodni kiriting'.tr}:', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)
                                                  ),
                                                  Container(
                                                      width: Get.width,
                                                      margin: EdgeInsets.only(left: 25.w, right: 25.w),
                                                      child: TextSmall(text: '${'Faollashtirish kodi'.tr} ${'raqamiga SMS tarzida yuborildi.'.tr}', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontWeight: FontWeight.w500, maxLines: 3)
                                                  ),
                                                  SizedBox(height: Get.height * 0.02),
                                                  AnimatedOpacity(
                                                      opacity: animateTextFields ? 1.0 : 1.0,
                                                      duration: const Duration(milliseconds: 1500), // Kechikish bilan paydo bo'lish
                                                      child: Obx(() =>
                                                          Pinput(
                                                              length: 5,
                                                              defaultPinTheme: defaultPinTheme,
                                                              focusedPinTheme: focusedPinTheme,
                                                              submittedPinTheme: submittedPinTheme,
                                                              showCursor: false,
                                                              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                                              forceErrorState: _getController.errorField.value,
                                                              errorBuilder: (context, error) => TextSmall(text: error, color: AppColors.red, fontWeight: FontWeight.w500),
                                                              errorPinTheme: _getController.errorFieldOk.value ? successPinTheme : errorPinTheme,
                                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                              controller: _getController.verifyCodeControllers,
                                                              keyboardType: TextInputType.number,
                                                              errorTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                                                              onCompleted: (value) {
                                                                ApiController().verifyPhone();
                                                              }
                                                          )
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03,top: Get.height * 0.01),
                                                      child: Obx(() =>_getController.countdownDuration.value.inSeconds == 0
                                                          ? TextButton(style: ButtonStyle(overlayColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onSurface.withOpacity(0.1))), onPressed: () {ApiController().sendCode();_getController.resetTimer();}, child: TextSmall(text: 'Kodni qayta yuborish', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500))
                                                          : TextButton(style: ButtonStyle(overlayColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onSurface.withOpacity(0.1))), onPressed: () {}, child: TextSmall(text: '${'Kodni qayta yuborish'}: ${_getController.countdownDuration.value.inMinutes.toString().padLeft(2, '0')}:${(_getController.countdownDuration.value.inSeconds % 60).toString().padLeft(2, '0')}', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500))
                                                      )
                                                  )
                                                ]
                                            )
                                        )
                                      ]
                                  )
                              )
                            ]
                        )
                    )
                )
            )
        )
    );
  }
}
