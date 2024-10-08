import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';

class GuaranteePage extends StatelessWidget {
  GuaranteePage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: TextLarge(text: '  Kafolat Muddatlari', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1)
      ),
      body: RefreshComponent(
        refreshController: _getController.refreshGuaranteeController,
        scrollController: _getController.scrollGuaranteeController,
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.01),
            SearchTextField(color: Colors.grey.withOpacity(0.2)),
            Container(
                width: Get.width,
                margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h, bottom: 15.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _getController.listImage.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        Column(
                            children: [
                              index == 0 || index == 2 || index == 3 ? Container(margin: EdgeInsets.only(bottom: 20.h), padding: EdgeInsets.only(left: Get.width * 0.015, right: Get.width * 0.015), child: TextSmall(text: index == 0 ? 'Bugun' : index == 2 ? 'Kecha' : '15 Sentabr', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w400)) : Container(),
                              Container(
                                  padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 9.h),
                                  margin: EdgeInsets.only(bottom: 15.h),
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? Colors.white : AppColors.black70, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0))], borderRadius: BorderRadius.circular(18.r)),
                                  child: Column(
                                      children: [
                                        Row(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(right: 15.w),
                                                  width: Get.width * 0.36,
                                                  height: Get.height * 0.13,
                                                  child:  Stack(
                                              children: [
                                                Positioned(
                                                    width: 2,
                                                    height: Get.height * 0.11,
                                                    child: Center(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        width: 2.w,
                                                        height: Get.height * 0.09,
                                                        decoration: BoxDecoration(
                                                            color: AppColors.black,
                                                            borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                                            boxShadow: [
                                                              BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))
                                                            ]
                                                        ),
                                                      )
                                                    )
                                                ),
                                                Positioned(
                                                  right: 0,
                                                    width: 2,
                                                    height: Get.height * 0.11,
                                                    child: Center(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          width: 2.w,
                                                          height: Get.height * 0.09,
                                                          decoration: BoxDecoration(
                                                              color: AppColors.black,
                                                              borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                              boxShadow: [
                                                                BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))
                                                              ]
                                                          ),
                                                        )
                                                    )
                                                ),
                                                Positioned.fill(
                                                    child: Container(
                                                        width: Get.width * 0.30,
                                                        height: Get.height * 0.11,
                                                        decoration: const BoxDecoration(color: AppColors.white),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                            child: FadeInImage(
                                                                image: NetworkImage(_getController.listImage[index]),
                                                                placeholder: NetworkImage(_getController.listImage[index]),
                                                                imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                                fit: BoxFit.contain
                                                            )
                                                        )
                                                    )
                                                )
                                              ]
                                            )
                                              ),
                                              Expanded(
                                                  child:  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(width: 110.w, child: TextSmall(text: _getController.listImagePrice[index].toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold,fontSize: 18.sp)),
                                                            const Spacer(),
                                                            Icon(Icons.delete, color: index == 2 ? AppColors.red : AppColors.red, size: 18),
                                                            SizedBox(width: 12.w)
                                                          ]
                                                      ),
                                                      SizedBox(height: 12.h),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: 'Kategoriya:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 11.sp)),
                                                            SizedBox(
                                                                width: Get.width * 0.225,
                                                                child: TextSmall(text: _getController.listImageName[index], color: AppColors.black, fontWeight: FontWeight.bold,fontSize: 11.sp)
                                                            )
                                                          ]
                                                      ),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: 'Qo`shilgan:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 11.sp)),
                                                            SizedBox(
                                                                width: Get.width * 0.225,
                                                                child: TextSmall(text: _getController.listPriceAnd[index], color: AppColors.black, fontWeight: FontWeight.bold,fontSize: 11.sp)
                                                            )
                                                          ]
                                                      ),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: 'Kafolat:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 11.sp)),
                                                            SizedBox(
                                                                width: Get.width * 0.225,
                                                                child: TextSmall(text: _getController.listPrice[index].toString(), color: AppColors.black, fontWeight: FontWeight.bold,fontSize: 11.sp)
                                                            )
                                                          ]
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Row(
                                                          children: [
                                                            Container(
                                                                width: 80.w,
                                                                padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                                decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(11.r)),
                                                                child: Center(child: TextSmall(text: index == 2 ? 'Faol emas' : 'Faol', color: index == 2 ? AppColors.white : AppColors.white, fontSize: 11.sp))
                                                            ),
                                                            const Spacer(),
                                                            Icon(Icons.archive_outlined, color: index == 2 ? AppColors.black70 : AppColors.black70, size: 23.sp),
                                                            SizedBox(width: 11.w)
                                                          ]
                                                      )
                                                    ]
                                                )
                                              )
                                            ]
                                        )
                                      ]
                                  )
                              )
                            ]
                        )
                )
            )
          ]
        )
      )
    );
  }
}