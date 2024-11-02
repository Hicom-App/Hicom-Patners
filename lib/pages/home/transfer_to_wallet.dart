import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../companents/filds/text_field_custom.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'add_card_page.dart';

class TransferToWallet extends StatelessWidget {
  final int index;
  TransferToWallet({super.key, required this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    _getController.clearCardsModel();
    _getController.getSelectedCardIndex;
    ApiController().getCards();
    return Scaffold(
        backgroundColor: AppColors.greys,
        appBar: AppBar(backgroundColor: AppColors.greys, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: 'Kartaga o`tkazmalar'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
        body: Obx(() => _getController.cardsModel.value.result != null ? RefreshComponent(
            refreshController: _getController.refreshTransferWalletController,
            scrollController: _getController.scrollTransferWalletController,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: Get.width, margin: EdgeInsets.only(left: 20.w, right: 20.w), child: TextSmall(text: 'To`lovga tasdiqlangan'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
                  Container(
                      width: Get.width,
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 11.h),
                      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h, bottom: 5.h),
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                      child: Row(
                          children: [
                            Icon(EneftyIcons.card_bold, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: 35.sp),
                            SizedBox(width: 10.w),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextSmall(text: 'Tasdiqlangan keshbek'.tr, color: AppColors.black, fontSize: 11.sp, fontWeight: FontWeight.w500),
                                  Row(
                                      children: [
                                        TextSmall(text: _getController.profileInfoModel.value.result!.first.cashbackCalculated.toString(), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 21.sp),
                                        TextSmall(text: ' so`m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                                      ]
                                  )
                                ]
                            )
                          ]
                      )
                  ),
                  SizedBox(height: 35.h),
                  Container(width: Get.width, margin: EdgeInsets.only(left: 15.w, right: 15.w), child: TextSmall(text: 'Mening kartalarim'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 15.sp)),
                  ListView.builder(
                    itemCount: _getController.cardsModel.value.result!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Obx(() => InkWell(
                        onTap: () => _getController.saveSelectedCardIndex(index),
                        overlayColor: const WidgetStatePropertyAll(AppColors.blackTransparent),
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            //width: _getController.selectedCard.value == index ? Get.width * 0.9 : Get.width * 0.8,
                            width: Get.width,
                            margin: EdgeInsets.only(left: _getController.selectedCard.value == index? 15.w : 25.w, right: _getController.selectedCard.value == index? 15.w : 25.w, top: 8.h),
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: _getController.selectedCard.value == index? AppColors.blue : Colors.transparent, width: 2.w),
                              boxShadow: [BoxShadow(color: AppColors.black70.withOpacity(0.1), blurRadius: 25.r, spreadRadius: 25.r, offset: const Offset(0, 1))],
                              image: const DecorationImage(image: AssetImage('assets/images/card_fon.png'), fit: BoxFit.cover),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 50.h, width: 50.w, margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h), child: SvgPicture.asset(_getController.cardsModel.value.result![index].cardNo!.startsWith('9860') ? 'assets/svg_assets/uz_card.svg' : 'assets/svg_assets/humo.svg', colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn), fit: BoxFit.contain)),
                                  TextSmall(text: _getController.formatNumber(_getController.cardsModel.value.result![index].cardNo!), color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                                  TextSmall(text: _getController.cardsModel.value.result![index].cardHolder!, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                  SizedBox(height: 4.h)
                                ]
                            )
                        )
                    ))
                  ),
                  if (_getController.cardsModel.value.result!.isEmpty || _getController.cardsModel.value.result!.length == 1)
                    //InkWell(overlayColor: const WidgetStatePropertyAll(AppColors.blackTransparent), onTap: () => InstrumentComponents().bottomSheetMeCards(context), child: Container(width: Get.width, height: 136.h, margin: EdgeInsets.only(left: 28.w, right: 28.w,bottom: 12.h), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10.r, spreadRadius: 10.r, offset: const Offset(0, 0))]), child: Center(child: Icon(EneftyIcons.add_circle_outline, color: AppColors.greys, size: 70.sp)))),
                    InkWell(overlayColor: const WidgetStatePropertyAll(AppColors.blackTransparent), onTap: () => Get.to(() => AddCardPage()), child: Container(width: Get.width, height: 136.h, margin: EdgeInsets.only(left: 28.w, right: 28.w,bottom: 12.h), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10.r, spreadRadius: 10.r, offset: const Offset(0, 0))]), child: Center(child: Icon(EneftyIcons.add_circle_outline, color: AppColors.greys, size: 70.sp)))),
                  Container(
                      width: Get.width,
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 10.h),
                      child: TextSmall(text: 'To`lov summasi'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                  ),
                  TextFieldCustom(fillColor: AppColors.white, hint: '828', controller: _getController.cardNumberController),
                  SizedBox(height: Get.height * 0.025),
                  Container(
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), minimumSize: Size(Get.width, 50.h)),
                          onPressed: (){},
                          child: TextSmall(text: 'Jo‘natish'.tr, color: AppColors.white, fontWeight: FontWeight.w500)
                      )
                  )
                ]
            )
        ) : Skeletonizer(child: Column(
            children: [
              Container(width: Get.width, margin: EdgeInsets.only(left: 20.w, right: 20.w), child: TextSmall(text: 'To`lovga tasdiqlangan'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 11.h),
                  padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h, bottom: 5.h),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                      children: [
                        Icon(EneftyIcons.card_bold, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: 35.sp),
                        SizedBox(width: 10.w),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'Tasdiqlangan keshbek'.tr, color: AppColors.black, fontSize: 11.sp, fontWeight: FontWeight.w500),
                              Row(
                                  children: [
                                    TextSmall(text: '125 835', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 21.sp),
                                    TextSmall(text: ' so`m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                                  ]
                              )
                            ]
                        )
                      ]
                  )
              ),
              SizedBox(height: 35.h),
              Container(width: Get.width, margin: EdgeInsets.only(left: 15.w, right: 15.w), child: TextSmall(text: 'Mening kartalarim'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 15.sp)),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 8.h,),
                  padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10.h, bottom: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.grey),
                      boxShadow: [BoxShadow(color: AppColors.black70.withOpacity(0.1), blurRadius: 25.r, spreadRadius: 25.r, offset: const Offset(0, 1))],
                      image: DecorationImage(image: Image.asset('assets/images/card_fon.png').image, fit: BoxFit.cover)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50.h,
                            width: 50.w,
                            margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                            child: SvgPicture.asset('assets/svg_assets/uz_card.svg', colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn), fit: BoxFit.contain)
                        ),
                        TextSmall(text: '9860 3501 0156 4282', color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                        TextSmall(text: _getController.fullName.value, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                        SizedBox(height: 4.h)
                      ]
                  )
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h,),
                  padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10.h, bottom: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: AppColors.black70.withOpacity(0.1), blurRadius: 25.r, spreadRadius: 25.r, offset: const Offset(0, 1))],
                      image: DecorationImage(image: Image.asset('assets/images/card_fon.png').image, fit: BoxFit.cover)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50.h,
                            width: 50.w,
                            margin: EdgeInsets.only(right: 10.w, top: 15.h, bottom: 10.h),
                            child: SvgPicture.asset('assets/svg_assets/uz_card.svg', colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn), fit: BoxFit.contain)
                        ),
                        TextSmall(text: '9860 3501 0156 4282', color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 18.sp),
                        TextSmall(text: _getController.fullName.value, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                        SizedBox(height: 4.h)
                      ]
                  )
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 10.h),
                  child: TextSmall(text: 'To`lov summasi'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
              ),
              TextFieldCustom(fillColor: AppColors.white, hint: '828', controller: _getController.cardNumberController),
              SizedBox(height: Get.height * 0.025),
              Container(
                  margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), minimumSize: Size(Get.width, 50.h)),
                      onPressed: (){},
                      child: TextSmall(text: 'Jo‘natish'.tr, color: AppColors.white, fontWeight: FontWeight.w500)
                  )
              )
            ]
        ))
        )
    );
  }
}