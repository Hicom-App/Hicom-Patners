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
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextLarge(text: _getController.fullName.value.toString(), color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
                TextSmall(text: 'ID: ${_getController.id.value.toString()}', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
              ]
          ),
          actions: [
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
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
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
                            decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? Colors.grey.withOpacity(0.2) : AppColors.greysBack, borderRadius: BorderRadius.circular(20.r)),
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
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                )
                                            )
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 110.w, child: TextSmall(text: 'Kategoriya:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                                                TextSmall(text: _getController.listImageName[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w300,fontSize: 14.sp)
                                              ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(width: 110.w, child: TextSmall(text: 'Qo`shilgan:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                                                  TextSmall(text: _getController.listPriceAnd[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(width: 110.w, child: TextSmall(text: 'Kafolat:', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                                                  TextSmall(text: _getController.listPrice[index].toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w300,fontSize: 14.sp)
                                                ]
                                            ),
                                            SizedBox(height: 5.h),
                                            Row(
                                                children: [
                                                  Container(
                                                    width: 80.w,
                                                    padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(12.r)),
                                                    child: Center(child: TextSmall(text: index == 2 ? 'Faol emas' : 'Faol', color: index == 2 ? AppColors.white : AppColors.white, fontSize: 13))
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(3),
                                                    margin: const EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.blue : AppColors.blue, shape: BoxShape.circle),
                                                    child: Icon(EneftyIcons.attach_circle_bold, color: index == 2 ? AppColors.white : AppColors.white, size: 18),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(3),
                                                    margin: const EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.red, shape: BoxShape.circle),
                                                    child: Icon(EneftyIcons.close_circle_bold, color: index == 2 ? AppColors.white : AppColors.white, size: 18),
                                                  )
                                                ]
                                            )
                                          ]
                                        )
                                      ]
                                  ),
                                  SizedBox(height: Get.height * 0.015),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        TextSmall(text: _getController.listImagePrice[index].toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
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