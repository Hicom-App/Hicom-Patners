import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/auth/register_page.dart';
import 'package:hicom_patners/pages/auth/verify_page_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import '../../companents/filds/text_field_custom.dart';
import '../../companents/filds/text_field_register.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../sample/sample_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
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

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(color: AppColors.blue),
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r)
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: AppColors.grey.withOpacity(0.1)
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: AppColors.red.withOpacity(0.1),
          border: Border.all(color: AppColors.red),
          borderRadius: BorderRadius.circular(10.r)
      ),
    );

    final successPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: AppColors.green.withOpacity(0.1),
          border: Border.all(color: AppColors.green),
          borderRadius: BorderRadius.circular(10.r)
      ),
    );
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (!isKeyboardVisible) {
      _startDelayedAnimation();
    }

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
                                  top: Get.height * 0.05,
                                  left: 0,
                                  child: IconButton(onPressed: () {Get.back();}, icon: Icon(Icons.arrow_back_rounded, color: AppColors.white, size: 45.sp))
                              ),
                              Positioned.fill(
                                  child: Column(
                                      children: [
                                        //izedBox(height: Get.height * 0.1),
                                        AnimatedSlide(
                                            offset: animateTextFields ? const Offset(0, 0.13) : const Offset(0, 0.3),
                                            duration: Duration(milliseconds: animateTextFields ? 550 : 400),
                                            curve: Curves.easeInOut, // Uyg'un ravishda
                                            child: Container(
                                              padding: EdgeInsets.only(left: Get.width * 0.1, right: Get.width * 0.1),
                                              child: Column(
                                                  children: [
                                                    SizedBox(width: Get.width, child: TextLarge(text: '${'Ro‘yhatdan o‘tish'.tr}:', color: AppColors.black, fontWeight: FontWeight.bold)),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.02),
                                                        child: TextSmall(text: 'Ism', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)
                                                    ),
                                                    SizedBox(height: Get.height * 0.01),
                                                    AnimatedOpacity(
                                                      opacity: animateTextFields ? 1.0 : 1.0,
                                                      duration: const Duration(milliseconds: 1500), // Kechikish bilan paydo bo'lish
                                                      child: TextFieldRegister(
                                                        fillColor: AppColors.white,
                                                        hint: 'Dilshodjon',
                                                        controller: _getController.nameController,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.013),
                                                        child: TextSmall(text: 'Familya', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)
                                                    ),
                                                    SizedBox(height: Get.height * 0.01),
                                                    AnimatedOpacity(
                                                      opacity: animateTextFields ? 1.0 : 1.0,
                                                      duration: const Duration(milliseconds: 1500), // Kechikish bilan paydo bo'lish
                                                      child: TextFieldRegister(
                                                        fillColor: AppColors.white,
                                                        hint: 'Haydarov',
                                                        controller: _getController.nameController,
                                                      ),
                                                    ),
                                                    SizedBox(height: Get.height * 0.01),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            TextSmall(text: 'kun / oy / yil', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp),
                                                            Container(
                                                                width: Get.width * 0.39,
                                                                height: 40.h,
                                                                margin: EdgeInsets.only(top: Get.height * 0.01),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
                                                                    color: AppColors.white
                                                                )
                                                            ),
                                                          ]
                                                        ),
                                                        SizedBox(width: Get.width * 0.02),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              TextSmall(text: 'Foydalanuvchi', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp),
                                                              Container(
                                                                  width: Get.width * 0.39,
                                                                  height: 40.h,
                                                                  margin: EdgeInsets.only(top: Get.height * 0.01),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                                                                      color: AppColors.white
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        child: TextSmall(text: 'Mamlakat', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)
                                                    ),
                                                    Container(
                                                        width: Get.width,
                                                        height: 40.h,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10.r),
                                                            color: AppColors.white
                                                        )
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        child: TextSmall(text: 'Mamlakat', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)
                                                    ),
                                                    Container(
                                                        width: Get.width,
                                                        height: 40.h,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10.r),
                                                            color: AppColors.white
                                                        )
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        child: TextSmall(text: 'Mamlakat', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 14.sp)
                                                    ),
                                                    Container(
                                                        width: Get.width,
                                                        height: 40.h,
                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10.r),
                                                            color: AppColors.white
                                                        )
                                                    )
                                                  ]
                                              )
                                            )
                                        ),
                                        const Spacer(),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                  height: 40.h,
                                                  margin: EdgeInsets.only(bottom: Get.height * 0.06),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r)))),
                                                      onPressed: () {
                                                        Get.offAll(SamplePage());
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward,
                                                          color: AppColors.white,
                                                          size: 30.sp
                                                      )
                                                  )
                                              )
                                            ]
                                        ),
                                        SizedBox(height: Get.height * 0.05)
                                      ]
                                  )
                              ),
                              Positioned(
                                  top: 0,
                                  child: AnimatedContainer(
                                      width: Get.width,
                                      height: isKeyboardVisible ? Get.height * 0.13 : Get.height * 0.13,
                                      duration: const Duration(milliseconds: 500), // Biroz ko'proq vaqt
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40.r), bottomRight: Radius.circular(40.r)),
                                          image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.fitWidth),
                                          boxShadow: [BoxShadow(color: Colors.grey.shade400, spreadRadius: 15, blurRadius: 30, offset: Offset(0, 2))]
                                      )
                                  )
                              ),
                            ]
                        )
                    )
                )
            )
        )
    );
  }
}
