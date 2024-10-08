import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import '../../companents/filds/text_field_custom.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class TransferToWallet extends StatelessWidget {
  final int index;
  TransferToWallet({super.key, required this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            title: TextSmall(text: 'Kartaga o`tkazmalar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
        body: RefreshComponent(
            refreshController: _getController.refreshTransferWalletController,
            scrollController: _getController.scrollTransferWalletController,
            child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Container(width: Get.width, margin: EdgeInsets.only(left: 20.w, right: 20.w), child: TextSmall(text: 'To`lovga tasdiqlangan'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
                  Container(
                      width: Get.width,
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                      decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? AppColors.greys : AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
                      child: Row(
                        children: [
                          Icon(EneftyIcons.card_bold, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: 40.sp),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(text: 'Tasdiqlangan keshbek'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
                              TextSmall(text: _getController.listProductPrice[index] + ' so`m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                            ]
                          )
                        ]
                      )
                  ),
                  SizedBox(height: 20.h),
                  Container(width: Get.width, margin: EdgeInsets.only(left: 15.w, right: 15.w), child: TextSmall(text: 'Mening kartalarim'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
                  GestureDetector(
                      onTap: () => InstrumentComponents().bottomSheetMeCards(context),
                      child: Container(
                          width: Get.width,
                          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h,),
                          padding: EdgeInsets.only(left: 10.w, right: 15.w, top: 10.h, bottom: 10.h),
                          decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                              image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[0]), fit: BoxFit.cover)
                          ),
                          child: Row(
                              children: [
                                SizedBox(
                                    height: 70.h,
                                    width: 70.w,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(300.r),
                                        child: FadeInImage(
                                            image: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                            placeholder: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                            imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                            fit: BoxFit.cover
                                        )
                                    )
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextSmall(text: _getController.fullName.value, color: AppColors.white, fontWeight: FontWeight.w500),
                                      TextSmall(text: '9860 **** **** 8996'.tr, color: AppColors.white, fontWeight: FontWeight.w500)
                                    ]
                                ),
                                const Spacer(),
                                Column(
                                    children: [
                                      Icon(Icons.keyboard_arrow_up, color: AppColors.blue, size: 20.sp),
                                      Icon(Icons.keyboard_arrow_down, color: AppColors.blue, size: 20.sp),
                                    ]
                                )
                              ]
                          )
                      )
                  ),
                  Container(
                      width: Get.width,
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h, bottom: 10.h),
                      child: TextSmall(text: 'To`lov summasi'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
                  ),
                  TextFieldCustom(fillColor: Theme.of(context).brightness == Brightness.light ? AppColors.greys : AppColors.grey.withOpacity(0.2), hint: '828', controller: _getController.noteProjectController),
                  SizedBox(height: Get.height * 0.05),
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
        )
    );
  }
}