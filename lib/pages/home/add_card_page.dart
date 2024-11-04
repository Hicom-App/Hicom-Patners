import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import '../../companents/filds/text_field_custom.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/shake_widget.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class AddCardPage extends StatelessWidget {
  final bool? isEdit;
  final int? index;
  AddCardPage({super.key, this.isEdit, this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    _getController.cardNumberController.clear();
    _getController.nameController.clear();
    _getController.cardNameText.value = '';
    _getController.cardNumberText.value = '';
    _getController.tapTimes(() {
      isEdit == true ? _getController.cardNumberController.text = _getController.cardsModel.value.result![index!].cardNo.toString().replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ') : null;
      isEdit == true ? _getController.nameController.text = _getController.cardsModel.value.result![index!].cardHolder.toString() : null;
      isEdit == true ? _getController.cardNameText.value = _getController.cardsModel.value.result![index!].cardHolder.toString() : null;
      isEdit == true ? _getController.cardNumberText.value = _getController.cardsModel.value.result![index!].cardNo.toString().replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ') : null;
      }, 1);
    return Scaffold(
        backgroundColor: AppColors.greys,
        appBar: AppBar(backgroundColor: AppColors.greys, foregroundColor: AppColors.black, surfaceTintColor: AppColors.greys, title: TextSmall(text: isEdit == true ? 'Kartani tahrirlash'.tr : 'Karta qo‘shish'.tr, color:AppColors.black, fontWeight: FontWeight.w500)),
        body: SingleChildScrollView(
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: Get.width, margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h), child: TextSmall(text: 'Karta ma`lumotlari'.tr, color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                Obx(() => Container(
                        width: Get.width,
                        height: 150.h,
                        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h,),
                        padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10.h, bottom: 10.h),
                        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(20.r), image: DecorationImage(image: Image.asset('assets/images/card_fon_1.png').image, fit: BoxFit.cover)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(_getController.cardNumberText.value.toString().contains('9860') || _getController.cardNumberText.value.toString().contains('6262') || _getController.cardNumberText.value.toString().contains('9861'))
                                Container(
                                    height: 50.h,
                                    width: 50.w,
                                    margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                                    child: SvgPicture.asset('assets/svg_assets/humo.svg', color: AppColors.white, fit: BoxFit.contain)
                                )
                              else if (_getController.cardNumberText.value.toString().contains('8600') || _getController.cardNumberText.value.toString().contains('5614') || _getController.cardNumberText.value.toString().contains('4578'))
                                Container(
                                    height: 50.h,
                                    width: 50.w,
                                    margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                                    child: SvgPicture.asset('assets/svg_assets/uz_card.svg', color: AppColors.white, fit: BoxFit.contain)
                                ),
                              //TextSmall(text: _getController.cardNumberText.value, color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                              TextSmall(text: _getController.cardNumberText.value, color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 20.sp, letterSpacing: 2.3.sp),
                              TextSmall(text: _getController.cardNameText.value, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 11.sp, letterSpacing: 0.1.sp),
                              SizedBox(height: 4.h)
                            ]
                        )
                    )),
                Container(width: Get.width,margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 28.h,bottom: 10.h), child: TextSmall(text: 'Karta raqami'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp)),
                Obx(() => ShakeWidget(
                  key: _getController.shakeKey[0],
                  shakeOffset: 5,
                  shakeCount: 15,
                  shakeDuration: const Duration(milliseconds: 500),
                  shakeDirection: Axis.horizontal, // Can be Axis.vertical or both
                  child: TextFieldCustom(fillColor: AppColors.white, hint: 'Karta raqami', mack: true, controller: _getController.cardNumberController, errorInput: _getController.errorInput[0], isNext: true, inputType: TextInputType.number),
                )),

                Container(width: Get.width,margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h,bottom: 10.h), child: TextSmall(text: 'Karta egasining ishmi familiyasi'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 14.sp)),
                Obx(() => ShakeWidget(
                  key: _getController.shakeKey[1],
                  shakeOffset: 5,
                  shakeCount: 15,
                  shakeDuration: const Duration(milliseconds: 500),
                  shakeDirection: Axis.horizontal, // Can be Axis.vertical or both
                  child: TextFieldCustom(fillColor: AppColors.white, hint: 'F.I.O', controller: _getController.nameController, errorInput: _getController.errorInput[1], isNext: true),
                )),
                SizedBox(height: 50.h),
                Container(
                    width: Get.width,
                    margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h,),
                    padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(EneftyIcons.info_circle_bold, color: AppColors.red, size: 25.h),
                          SizedBox(width: 20.w),
                          SizedBox(width: Get.width * 0.65, child: TextSmall(text: 'Iltimos, karta raqami va karta egasining ismi familiyasini to‘liq kiriting. Agar karta raqami yoki karta egasining ishmi familiyasi noto‘g‘ri bo‘lsa bu kartaga o‘tkazmani rad etishga sabab bo‘lishi mumkin.', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 10.sp, maxLines: 200))
                        ]
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 50.h, top: 30.h),
                    width: Get.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), backgroundColor: AppColors.blue, padding: EdgeInsets.only(top: 15.h, bottom: 15.h)),
                        onPressed: () {
                          if (_getController.cardNumberController.text.isEmpty && _getController.cardNumberController.text.length <= 16) {
                            _getController.changeErrorInput(0, true);
                            _getController.tapTimes(() =>_getController.changeErrorInput(0, false),1);
                            _getController.shakeKey[0].currentState?.shake();
                            return;
                          }
                          if (_getController.nameController.text.isEmpty) {
                            _getController.changeErrorInput(1, true);
                            _getController.tapTimes(() =>_getController.changeErrorInput(1, false),1);
                            _getController.shakeKey[1].currentState?.shake();
                            return;
                          }
                          if (isEdit == true && index != null) {
                            print('edit card');
                            ApiController().editCard(_getController.cardsModel.value.result![index!].id ?? 0);
                          } else {
                            print('add card');
                            ApiController().addCard();
                          }
                        },
                        child: TextSmall(
                            text: isEdit == true ? 'Saqlash'.tr : 'Qo‘shish'.tr,
                            color: AppColors.white)
                    )
                )
              ]
          )
        )
    );
  }
}