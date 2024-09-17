import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/custom_header.dart';
import '../../controllers/get_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GetController _getController = Get.put(GetController());

  void _getData() {
    _getController.refreshLibController.refreshCompleted();
  }

  void _onLoading() async {
    _getController.refreshLibController.refreshCompleted();
    _getController.refreshLibController.loadComplete();
  }

  var list = ['Camutator', 'switch', 'Poe', 'smart', 'HDD', 'camera', 'Hicom', 'Partners', 'Uz', 'biron bir narsada'];
  var listTitle = ['Jarayonda', 'Tasdiqlangan', 'To`langan','Rad etilgan'];
  var listPrice = ['2 285 404', '224 614', '223 786', '1 272 102'];
  var listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red];
  var listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://frankfurt.apollo.olxcdn.com/v1/files/t3uftbiso49d-UZ/image;s=3024x3024','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'];
  var listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera', 'Hicom', 'Partners', 'Uz', 'biron bir narsada'];
  var listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera', 'Hicom', 'Partners', 'Uz', 'biron bir narsada'];
  var listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greys,
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const CustomRefreshHeader(),
          footer: const CustomRefreshFooter(),
          onLoading: _onLoading,
          onRefresh: _getData,
          controller: _getController.refreshLibController,
          scrollController: _getController.scrollController,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                    height: Get.height * 0.42,
                    width: Get.width,
                    child: Stack(
                        children: [
                          Positioned.fill(child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: const RiveAnimation.asset('assets/shapes.riv', fit: BoxFit.cover))),
                          Positioned.fill(
                              child: Column(
                                children: [
                                  AppBar(
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
                                  const Spacer(),
                                  TextSmall(text: 'Jami hisoblangan'.tr, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                                  TextLarge(text: '2 510 018 so`m'.tr, color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.bold),
                                  SizedBox(height: Get.height * 0.02),
                                  Center(
                                      child: SizedBox(
                                          width: Get.width,
                                          height: Get.height * 0.1,
                                          child: ListView.builder(
                                              itemCount: listTitle.length,
                                              scrollDirection: Axis.horizontal,
                                              physics: const BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(left: Get.width * 0.05),
                                              itemBuilder: (context, index) => Card(
                                                  child:SizedBox(
                                                    height: Get.height * 0.12,
                                                    width: Get.width * 0.35,
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextSmall(text: listTitle[index].tr, color: AppColors.black),
                                                          TextSmall(text: listPrice[index].tr, color: listColor[index]),
                                                        ]),
                                                  )
                                              )
                                          )
                                      )
                                  ),
                                  const Spacer()
                                ]
                              )
                          )
                        ]
                    )
                ),
                Container(
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3)
                          )
                        ]),
                      child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: Get.width * 0.03, top: Get.height * 0.02, right: Get.width * 0.03),
                                height: Get.height * 0.05,
                                padding: EdgeInsets.only(right: Get.width * 0.01),
                                decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
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
                                margin: EdgeInsets.only(left: Get.width * 0.03, top: Get.height * 0.02, right: Get.width * 0.03),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      TextSmall(text: 'Tavsiya etiladi'.tr, color: Theme.of(context).colorScheme.onSurface),
                                      const Spacer(),
                                      TextButton(onPressed: () {}, child: TextSmall(text: 'ko`proq'.tr, color: AppColors.blue),)
                                    ]
                                )
                            ),
                            SizedBox(
                                height: Get.height * 0.21,
                                width: Get.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(left: Get.width * 0.03),
                                    itemBuilder: (context, index) => Container(
                                      height: Get.height * 0.14,
                                      width: Get.width * 0.3,
                                      margin: EdgeInsets.only(right: Get.width * 0.03),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
                                      ),
                                      child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
                                                child: FadeInImage(
                                                  image: NetworkImage(listImage[index]),
                                                    placeholder: NetworkImage(listImage[index]),
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextSmall(text: listImageName[index], color: AppColors.blue, fontSize: 13),
                                                    TextSmall(text: listImagePrice[index], color: AppColors.black),
                                                    Row(
                                                      children: [
                                                        //icon localtion
                                                        Icon(Icons.star, color: AppColors.backgroundApp,size: 11),
                                                        TextSmall(text: listStar[index],
                                                            color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10),
                                                      ],
                                                    )
                                                  ]
                                                )
                                              )
                                            ])
                                    ),
                                    itemCount: listImage.length
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(left: Get.width * 0.03, top: Get.height * 0.02, right: Get.width * 0.03),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      TextSmall(text: 'Barcha tovarlar'.tr, color: Theme.of(context).colorScheme.onSurface),
                                      const Spacer(),
                                      TextButton(onPressed: () {}, child: TextSmall(text: 'ko`proq'.tr, color: AppColors.blue))
                                    ]
                                )
                            ),
                            SizedBox(
                                height: Get.height * 0.21,
                                width: Get.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(left: Get.width * 0.03),
                                    itemBuilder: (context, index) => Container(
                                        height: Get.height * 0.14,
                                        width: Get.width * 0.3,
                                        margin: EdgeInsets.only(right: Get.width * 0.03),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(10.r),
                                          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
                                        ),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
                                                child: FadeInImage(
                                                    image: NetworkImage(listImage[index]),
                                                    placeholder: NetworkImage(listImage[index]),
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextSmall(text: listImageName[index], color: AppColors.blue, fontSize: 13),
                                                        TextSmall(text: listImagePrice[index], color: AppColors.black),
                                                        Row(
                                                          children: [
                                                            //icon localtion
                                                            Icon(Icons.star, color: AppColors.backgroundApp,size: 11),
                                                            TextSmall(text: listStar[index],
                                                                color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10),
                                                          ],
                                                        )
                                                      ]
                                                  )
                                              )
                                            ])
                                    ),
                                    itemCount: listImage.length
                                )
                            ),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01)
                          ]),
                    )
              ]
            )
          )
      ),
    );
  }
}