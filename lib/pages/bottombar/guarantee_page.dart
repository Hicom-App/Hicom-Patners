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

  void _getData() {
    _getController.refreshLibController.refreshCompleted();
  }

  void _onLoading() async {
    _getController.refreshLibController.refreshCompleted();
    _getController.refreshLibController.loadComplete();
  }

  var list = ['AI POE', 'NETWORK CABINET', 'HDD', 'PDU', 'CAMERA', 'ACSESSORIES', 'HDMI CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE'];
  var listPrice = ['12.02.2025', '12.02.2025', '17.09.2024', '12.02.2025','12.02.2025', '12.02.2025', '12.02.2025', '12.02.2025','12.02.2025', '12.02.2025', '12.02.2025', '12.02.2025',];
  var listPriceAnd = ['02.02.2022', '01.03.2022', '09.01.2022', '10.04.2022','03.05.2022', '06.03.2022', '11.07.2022', '12.07.2022','12.08.2022', '12.04.2022', '12.02.2022', '12.02.2022',];
  var listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red];
  var listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://frankfurt.apollo.olxcdn.com/v1/files/t3uftbiso49d-UZ/image;s=3024x3024','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'];
  var listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'PoE Switch', 'PoE Switch', 'PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera',];
  var listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'Hi-M42E', 'Hi-M82E', 'Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera'];
  var listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'];
  var listCategoryIcon = ['https://img.icons8.com/?size=100&id=91076&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=100062&format=png&color=475566','https://img.icons8.com/?size=100&id=108835&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566','https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=59749&format=png&color=475566','https://img.icons8.com/?size=100&id=110322&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566'];


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
                    itemCount: listImage.length,
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
                                                    image: NetworkImage(listImage[index]),
                                                    placeholder: NetworkImage(listImage[index]),
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
                                                TextSmall(text: listImageName[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                              ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110.w,
                                                    child: TextSmall(text: 'Qo`shilgan:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp),
                                                  ),
                                                  TextSmall(text: listPriceAnd[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110.w,
                                                    child: TextSmall(text: 'Kafolat:', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 14.sp),
                                                  ),
                                                  TextSmall(text: listPrice[index], color: AppColors.black,fontWeight: FontWeight.w300,fontSize: 14.sp),
                                                ]
                                            ),

                                            SizedBox(height: 5.h),
                                            Row(
                                                children: [
                                                  Container(
                                                    width: 80.w,
                                                    padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(12.r)),
                                                    child: Center(child: TextSmall(
                                                        text: index == 2 ? 'faol emas' : 'faol',
                                                        color: index == 2 ? AppColors.white : AppColors.white, fontSize: 13),)
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(color: index == 2 ? AppColors.blue : AppColors.blue, shape: BoxShape.circle),
                                                    child: Icon(Icons.archive_rounded, color: index == 2 ? AppColors.white : AppColors.white, size: 15),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(left: 5),
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
                                        //TextSmall(text: listImageName[index], color: AppColors.black,fontWeight: FontWeight.w500),
                                        TextSmall(text: listImagePrice[index], color: AppColors.black,fontWeight: FontWeight.w500),
                                      ]
                                  ),

                                ]
                            )
                        )
                      ],
                    )
                )
            )
          ],
        )
      )
    );
  }
}