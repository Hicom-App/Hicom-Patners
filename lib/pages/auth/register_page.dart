import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/auth/verify_page_number.dart';
import '../../companents/filds/text_field_register.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final GetController _getController = Get.put(GetController());


  @override
  void initState() {
    super.initState();
    _getController.startDelayedAnimation();
  }


  @override
  Widget build(BuildContext context) {
    _getController.isKeyboardVisible.value = MediaQuery.of(context).viewInsets.bottom != 0;

    if (!_getController.isKeyboardVisible.value) {
      _getController.startDelayedAnimation();
    }

    ApiController().getCountries();
    _getController.updateSelectedDate(DateTime.now());


    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                              Positioned.fill(
                                  child: Column(
                                      children: [
                                        AnimatedSlide(
                                            offset: !_getController.animateTextFields.value ? const Offset(0, 0.13) : const Offset(0, 0.3),
                                            duration: Duration(milliseconds: _getController.animateTextFields.value ? 550 : 400),
                                            curve: Curves.easeInOut, // Uyg'un ravishda
                                            child: Container(
                                              width: Get.width,
                                              padding: EdgeInsets.only(left: 25.w, right: 25.w),
                                              child: Column(
                                                  children: [
                                                    SizedBox(width: Get.width, child: TextLarge(text: '${'Ro‘yhatdan o‘tish'.tr}:', color: AppColors.black, fontWeight: FontWeight.bold)),
                                                    Container(width: Get.width, margin: EdgeInsets.only(top: Get.height * 0.02), child: TextSmall(text: 'Ism', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)),
                                                    SizedBox(height: Get.height * 0.01),
                                                    AnimatedOpacity(
                                                      opacity: _getController.animateTextFields.value ? 1.0 : 1.0,
                                                      duration: const Duration(milliseconds: 1500), // Kechikish bilan paydo bo'lish
                                                      child: TextFieldRegister(fillColor: AppColors.white, hint: 'Dilshodjon', controller: _getController.nameController)
                                                    ),
                                                    Container(
                                                        width: Get.width,
                                                        margin: EdgeInsets.only(top: Get.height * 0.013),
                                                        child: TextSmall(text: 'Familya', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)
                                                    ),
                                                    SizedBox(height: Get.height * 0.01),
                                                    AnimatedOpacity(
                                                      opacity: _getController.animateTextFields.value ? 1.0 : 1.0,
                                                      duration: const Duration(milliseconds: 1500),
                                                      child: TextFieldRegister(fillColor: AppColors.white, hint: 'Haydarov', controller: _getController.surNameController)
                                                    ),
                                                    SizedBox(height: Get.height * 0.01),
                                                    Row(
                                                      children: [
                                                        Expanded(child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              TextSmall(text: 'kun / oy / yil', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp),
                                                              InkWell(
                                                                  onTap: () => _getController.showCupertinoDatePicker(context),
                                                                  child: Container(
                                                                      height: 40.h,
                                                                      margin: EdgeInsets.only(top: Get.height * 0.01),
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)), color: AppColors.white),
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Obx(() => TextSmall(
                                                                                text: _getController.formattedDate.value.toString(), // Use .value to access the DateTime
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                maxLines: 3,
                                                                                fontSize: 13.sp
                                                                            )),
                                                                            const Icon(Icons.keyboard_arrow_down, color: AppColors.black)
                                                                          ]
                                                                      )
                                                                  )
                                                              )
                                                            ]
                                                        )),

                                                        SizedBox(width: Get.width * 0.02),
                                                        Expanded(
                                                          child: InkWell(
                                                              onTap: () => InstrumentComponents().bottomBuildLanguageDialog(context,'Foydalanuvchi turi','0'),
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    TextSmall(text: 'Foydalanuvchi', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp),
                                                                    Container(
                                                                      // width: Get.width * 0.,
                                                                        height: 40.h,
                                                                        margin: EdgeInsets.only(top: Get.height * 0.01),
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r)), color: AppColors.white),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
                                                                            Obx(() => TextSmall(
                                                                              //text: _getController.dropDownItems[2], // Use .value to access the DateTime
                                                                                text: _getController.dropDownItem[_getController.dropDownItems[0]].toString(),
                                                                                color: AppColors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                maxLines: 3,
                                                                                fontSize: 13.sp
                                                                            ))
                                                                          ]
                                                                        )
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(width: Get.width, margin: EdgeInsets.only(top: Get.height * 0.01), child: TextSmall(text: 'Mamlakat', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)),
                                                    InkWell(
                                                      onTap: () {
                                                        _getController.countriesModel.value.countries == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Mamlakat',0);
                                                        },
                                                        child: Container(
                                                            width: Get.width,
                                                            height: 40.h,
                                                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                                            margin: EdgeInsets.only(top: Get.height * 0.01),
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.white),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Obx(() => TextSmall(text: _getController.dropDownItemsCountries.isNotEmpty ? _getController.dropDownItemsCountries[_getController.dropDownItems[1]].toString() : 'Mamlakat', color: _getController.dropDownItemsCountries.isNotEmpty ? AppColors.black : AppColors.black70, fontWeight: FontWeight.w500, maxLines: 3, fontSize: 13.sp)),
                                                                  const Icon(Icons.keyboard_arrow_down, color: AppColors.black)
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(width: Get.width, margin: EdgeInsets.only(top: Get.height * 0.01), child: TextSmall(text: 'Viloyat', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 13.sp)),
                                                    InkWell(
                                                      onTap: () => _getController.regionsModel.value.regions == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Viloyat',1),
                                                      child: Container(
                                                          width: Get.width,
                                                          height: 40.h,
                                                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                                          margin: EdgeInsets.only(top: Get.height * 0.01),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.white),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Obx(() => TextSmall(text: _getController.dropDownItemsRegions.isNotEmpty ? _getController.dropDownItemsRegions[_getController.dropDownItems[2]].toString() : 'Viloyatingizni Tanlang', color: _getController.dropDownItemsRegions.isNotEmpty ?AppColors.black : AppColors.black70, fontWeight: FontWeight.w500, maxLines: 3, fontSize: 13.sp)),
                                                                const Icon(Icons.keyboard_arrow_down, color: AppColors.black)
                                                              ]
                                                          )
                                                      )
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Container(width: Get.width, margin: EdgeInsets.only(top: Get.height * 0.01), child: TextSmall(text: 'Shaxar', color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 3,fontSize: 14.sp)),
                                                    InkWell(
                                                      onTap: () => _getController.citiesModel.value.cities == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Shaxar',2),
                                                      child: Container(
                                                          width: Get.width,
                                                          height: 40.h,
                                                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                                          margin: EdgeInsets.only(top: Get.height * 0.01),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.white),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Obx(() => TextSmall(text: _getController.dropDownItemsCities.isNotEmpty ? _getController.dropDownItemsCities[_getController.dropDownItems[3]].toString() : 'Qo‘qon', color:_getController.dropDownItemsCities.isNotEmpty ? AppColors.black : AppColors.black70, fontWeight: FontWeight.w500, maxLines: 3, fontSize: 13.sp)),
                                                                const Icon(Icons.keyboard_arrow_down, color: AppColors.black)
                                                              ]
                                                          )
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
                                                      onPressed: () => ApiController().updateProfile,
                                                      child: Icon(Icons.arrow_forward, color: AppColors.white, size: 30.sp)
                                                  )
                                              )
                                            ]
                                        )
                                      ]
                                  )
                              ),
                              Positioned(
                                  top: 0,
                                  child: AnimatedContainer(
                                      width: Get.width,
                                      height: _getController.isKeyboardVisible.value ? Get.height * 0.13 : Get.height * 0.13,
                                      duration: const Duration(milliseconds: 500), // Biroz ko'proq vaqt
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40.r), bottomRight: Radius.circular(40.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.fitWidth), boxShadow: [BoxShadow(color: Colors.grey.shade400, spreadRadius: 15, blurRadius: 30, offset: const Offset(0, 2))])
                                  )
                              ),
                              Positioned(top: Get.height * 0.05, left: 10, child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_rounded, color: AppColors.white, size: 45.sp)))
                            ]
                        )
                    )
                )
            )
        )
    );
  }
}
