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
          actions: [
            SizedBox(width: 15.w),
            TextLarge(text: '  Kafolat Muddatlari', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1),
            const Spacer(),
            IconButton(icon: Icon(EneftyIcons.notification_bold, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
          ]
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
                padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h, bottom: 15.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _getController.listImage.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        Column(
                          children: [index == 0 || index == 2 || index == 3 ? Container(
                            margin: EdgeInsets.only(bottom: Get.width * 0.02),
                            padding: EdgeInsets.only(left: Get.width * 0.015, right: Get.width * 0.015),
                            child: TextSmall(text: index == 0 ? 'Bugun' : index == 2 ? 'Kecha' : '15 Sentabr', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w400),
                          ) : Container(),
                            Container(
                            padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
                            margin: EdgeInsets.only(bottom: 15.h),
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.light ? Colors.white : AppColors.black70,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0))],
                                borderRadius: BorderRadius.circular(20.r)),
                            child: Column(
                                children: [
                                  Row(
                                      children: [
                                        Container(
                                            width: Get.width * 0.22,
                                            height: Get.height * 0.11,
                                            margin: EdgeInsets.only(right: 15.w),
                                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                child: FadeInImage(
                                                    image: NetworkImage(_getController.listImage[index]),
                                                    placeholder: NetworkImage(_getController.listImage[index]),
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                )
                                            )
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width:  Get.width * 0.56,
                                                child: Row(
                                                    children: [
                                                      SizedBox(width: 110.w, child: TextSmall(text: _getController.listImagePrice[index].toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold,fontSize: 18.sp)),
                                                      const Spacer(),
                                                      Icon(EneftyIcons.note_remove_bold, color: index == 2 ? AppColors.red : AppColors.red, size: 18),
                                                    ]
                                                )
                                            ),

                                            TextSmall(text: index == 2 ? 'Faol emas' : 'Faol', color: index == 2 ? AppColors.white : AppColors.black, fontSize: 11),
                                            SizedBox(height: 5.h),
                                            Row(
                                              children: [
                                                SizedBox(width: 110.w, child: TextSmall(text: 'Kategoriya:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 13.sp)),
                                                TextSmall(text: _getController.listImageName[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold,fontSize: 13.sp)
                                              ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(width: 110.w, child: TextSmall(text: 'Qo`shilgan:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 13.sp)),
                                                  TextSmall(text: _getController.listPriceAnd[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,fontWeight: FontWeight.bold,fontSize: 13.sp),
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(width: 110.w, child: TextSmall(text: 'Kafolat:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 13.sp)),
                                                  TextSmall(text: _getController.listPrice[index].toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold,fontSize: 13.sp)
                                                ]
                                            ),
                                            SizedBox(height: 5.h),
                                            SizedBox(
                                              width:  Get.width * 0.56,
                                              child: Row(
                                                  children: [
                                                    Container(
                                                        width: 80.w,
                                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                        decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(12.r)),
                                                        child: Center(child: TextSmall(text: index == 2 ? 'Faol emas' : 'Faol', color: index == 2 ? AppColors.white : AppColors.white, fontSize: 13))
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      padding: const EdgeInsets.all(3),
                                                      margin: const EdgeInsets.only(left: 5),
                                                      decoration: BoxDecoration(color: index == 2 ? AppColors.blue : AppColors.blue, shape: BoxShape.circle),
                                                      child: Icon(EneftyIcons.attach_circle_bold, color: index == 2 ? AppColors.white : AppColors.white, size: 18),
                                                    )
                                                  ]
                                              )
                                            )
                                          ]
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