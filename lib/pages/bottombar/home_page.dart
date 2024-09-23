import 'dart:ui';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/home/category_page.dart';
import 'package:hicom_patners/pages/home/detail_page.dart';
import 'package:hicom_patners/pages/home/notification_page.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:rive/rive.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../home/transfer_to_wallet.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grey.withOpacity(0.1),
        body: RefreshComponent(
            scrollController: _getController.scrollController,
            refreshController: _getController.refreshController,
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
                                            IconButton(icon: Icon(EneftyIcons.notification_bold, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.to(() =>  NotificationPage())),
                                          ]
                                      ),
                                      const Spacer(),
                                      TextSmall(text: 'Jami hisoblangan'.tr, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                                      TextLarge(text: '2 510 018 so`m'.tr, color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.bold),
                                      SizedBox(height: Get.height * 0.02),
                                      SizedBox(
                                        width: Get.width,
                                        height: Get.height * 0.1,
                                        child: ListView.builder(
                                          itemCount: _getController.listTitle.length,
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          padding: EdgeInsets.only(left: Get.width * 0.05),
                                          itemBuilder: (context, index) => GestureDetector(
                                            onTap: () {
                                              if( index == 1) {
                                                Get.to(() => TransferToWallet(index: index));
                                              }
                                            },
                                            child: Card(
                                              color: AppColors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                                              child: SizedBox(
                                                height: Get.height * 0.12,
                                                width: Get.width * 0.35,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextSmall(text: _getController.listTitle[index].tr, color: AppColors.black),
                                                    TextSmall(text: _getController.listProductPrice[index].tr, color: _getController.listColor[index], fontWeight: FontWeight.bold)
                                                  ]
                                                )
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
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), boxShadow: [
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
                              decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(20.r)),
                              child: TextField(
                                  controller: _getController.searchController,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                      hintText: 'Qidirish'.tr,
                                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Get.width * 0.04),
                                      prefixIcon: Padding(padding: EdgeInsets.all(Get.height * 0.013), child: Icon(EneftyIcons.search_normal_2_outline, color: Theme.of(context).colorScheme.onSurface)),
                                      border: InputBorder.none
                                  )
                              )
                          ),
                          SizedBox(height: Get.height * 0.02),
                          SizedBox(
                              width: Get.width * 0.97,
                              height: Get.height * 0.08,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () => Get.to(CategoryPage()),
                                      child:  Container(
                                          margin: EdgeInsets.only(left: Get.width * 0.03),
                                          padding: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.01),
                                          decoration: BoxDecoration(
                                              color: AppColors.white,
                                              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
                                              borderRadius: BorderRadius.circular(20.r)),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * 0.06,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(10.r)),
                                                      child: FadeInImage(
                                                          image: NetworkImage(_getController.listCategoryIcon[index]),
                                                          placeholder:NetworkImage(_getController.listCategoryIcon[index]),
                                                          imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://img.icons8.com/?size=100&id=91076&format=png&color=000000'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(20.r))));},
                                                          fit: BoxFit.cover
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(top: Get.height * 0.01),
                                                    width: Get.width * 0.15,
                                                    child: Center(child: TextSmall(text: _getController.list[index].tr, color: AppColors.black.withOpacity(0.7), maxLines: 1, fontSize: 10.sp))
                                                )
                                              ]
                                          )
                                      )
                                  ),
                                  itemCount: 10,
                                  shrinkWrap: true
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
                                    TextButton(onPressed: () {}, child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.blue),)
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
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () => Get.to(DetailPage(index: index)),
                                      child: Container(
                                          height: Get.height * 0.14,
                                          width: Get.width * 0.3,
                                          margin: EdgeInsets.only(right: Get.width * 0.03),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(20.r),
                                            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
                                          ),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                                                        child: FadeInImage(
                                                            image: NetworkImage(_getController.listImage[index]),
                                                            placeholder: NetworkImage(_getController.listImage[index]),
                                                            imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                    Positioned(right: 5, top: 5, child: Icon(index == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline, color: index == 1 ? Colors.red : Theme.of(context).colorScheme.onSurface, size: 20)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          TextSmall(text: _getController.listImageName[index], color: AppColors.blue, fontSize: 13),
                                                          Row(
                                                              children: [
                                                                TextSmall(text: _getController.listImagePrice[index], color: AppColors.black),
                                                              ]
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: 11),
                                                              TextSmall(text: _getController.listStar[index], color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10),
                                                            ],
                                                          )
                                                        ]
                                                    )
                                                )
                                              ])
                                      )
                                  ),
                                  itemCount: _getController.listImage.length
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
                                    TextButton(onPressed: () {}, child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.blue))
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
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 1),
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                                              child: FadeInImage(
                                                  image: NetworkImage(_getController.listImage[index]),
                                                  placeholder: NetworkImage(_getController.listImage[index]),
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
                                                      TextSmall(text: _getController.listImageName[index], color: AppColors.blue, fontSize: 13),
                                                      TextSmall(text: _getController.listImagePrice[index], color: AppColors.black),
                                                      Row(
                                                        children: [
                                                          const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: 11),
                                                          TextSmall(text: _getController.listStar[index],
                                                              color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10),
                                                        ],
                                                      )
                                                    ]
                                                )
                                            )
                                          ])
                                  ),
                                  itemCount: _getController.listImage.length
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
    );
  }
}