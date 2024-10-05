import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class ArxivPage extends StatelessWidget {
  ArxivPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            title: TextSmall(text: 'Arxivlangan tovarlar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
        body: RefreshComponent(
            refreshController: _getController.refreshArchiveController,
            scrollController: _getController.scrollArchiveController,
            child: Container(
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
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: TextSmall(text: index == 0 ? 'Bugun' : index == 2 ? 'Kecha' : '15 Sentabr', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w400),
                            ) : Container(),
                              Container(
                                  padding: EdgeInsets.only(left: 15.w, top: 15.w, bottom: 15.w),
                                  margin: EdgeInsets.only(bottom: 15.w),
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
                                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.all(Radius.circular(20.r))),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                      child: FadeInImage(
                                                          image: NetworkImage(_getController.listImage[index]),
                                                          placeholder: NetworkImage(_getController.listImage[index]),
                                                          imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), bottomRight: Radius.circular(20.r))));},
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
                                        SizedBox(height: 15.w),
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
        )
    );
  }
}
