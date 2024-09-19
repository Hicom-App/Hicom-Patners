import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
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
      backgroundColor: Colors.grey.withOpacity(0.1),
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
            IconButton(icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
          ]
      ),
      body: RefreshComponent(
        refreshController: _getController.refreshGuaranteeController,
        scrollController: _getController.scrollGuaranteeController,
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.01),
            Container(
                margin: EdgeInsets.only(left: Get.width * 0.03, top: Get.height * 0.02, right: Get.width * 0.03),
                height: Get.height * 0.05,
                padding: EdgeInsets.only(right: Get.width * 0.01),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15)),
                child: TextField(
                    controller: _getController.searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        hintText: 'Qidirish'.tr,
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Get.width * 0.04),
                        prefixIcon: Padding(padding: EdgeInsets.all(Get.height * 0.013), child: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface)),
                        border: InputBorder.none
                    )
                )
            ),
            Container(
                width: Get.width,
                height: Get.height,
                padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, top: Get.height * 0.015, bottom: Get.height * 0.015),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _getController.listImage.length,
                    itemBuilder: (context, index) =>
                        Column(
                          children: [index == 0 || index == 2 || index == 3 ? Container(
                            margin: EdgeInsets.only(bottom: Get.width * 0.02),
                            padding: EdgeInsets.only(left: Get.width * 0.015, right: Get.width * 0.015),
                            child: TextSmall(text: index == 0 ? 'Bugun' : index == 2 ? 'Kecha' : '15 Sentabr', color: AppColors.black.withOpacity(0.6), fontWeight: FontWeight.w400),
                          ) : Container(),
                        Container(
                            padding: EdgeInsets.only(left: Get.width * 0.03, top: Get.height * 0.015, bottom: Get.height * 0.015),
                            margin: EdgeInsets.only(bottom: Get.height * 0.015),
                            width: Get.width,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                children: [
                                  Row(
                                      children: [
                                        Container(
                                            width: Get.width * 0.22,
                                            height: Get.height * 0.11,
                                            margin: EdgeInsets.only(right: Get.width * 0.03),
                                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10.r)),
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
                                                SizedBox(
                                                  width: 110.w,
                                                  child: TextSmall(text: 'Kategoriya:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp),
                                                ),
                                                //TextSmall(text: listImagePrice[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                TextSmall(text: _getController.listImageName[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                              ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110.w,
                                                    child: TextSmall(text: 'Qo`shilgan:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp),
                                                  ),
                                                  TextSmall(text: _getController.listPriceAnd[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110.w,
                                                    child: TextSmall(text: 'Kafolat:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp),
                                                  ),
                                                  TextSmall(text: _getController.listPrice[index].toString(), color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                ]
                                            ),

                                            SizedBox(height: 5.h),
                                            Row(
                                                children: [
                                                  Container(
                                                    width: 80.w,
                                                    padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(12.r)),
                                                    child: Center(child: TextSmall(
                                                        text: index == 2 ? 'Faol emas' : 'Faol',
                                                        color: index == 2 ? AppColors.white : AppColors.white, fontSize: 13),)
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(5),
                                                    margin: const EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.blue : AppColors.blue, shape: BoxShape.circle),
                                                    child: Icon(Icons.archive_rounded, color: index == 2 ? AppColors.white : AppColors.white, size: 15),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(5),
                                                    margin: const EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.red, shape: BoxShape.circle),
                                                    child: Icon(Icons.delete, color: index == 2 ? AppColors.white : AppColors.white, size: 15),
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
                                        TextSmall(text: _getController.listImagePrice[index].toString(), color: AppColors.black,fontWeight: FontWeight.w500),
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