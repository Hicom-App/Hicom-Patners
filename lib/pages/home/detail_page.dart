import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class DetailPage extends StatelessWidget {
  final int index;
  DetailPage({super.key, required this.index});

  final GetController _getController = Get.put(GetController());


  var list = ['AI POE', 'NETWORK CABINET', 'HDD', 'PDU', 'CAMERA', 'ACSESSORIES', 'HDMI CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE'];
  var listTitle = ['Jarayonda', 'Tasdiqlangan', 'To`langan','Rad etilgan'];
  var listPrice = ['2 285 404', '224 614', '223 786', '1 272 102'];
  var listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red];
  var listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://frankfurt.apollo.olxcdn.com/v1/files/t3uftbiso49d-UZ/image;s=3024x3024','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'];
  var listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'PoE Switch', 'PoE Switch', 'PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera',];
  var listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'Hi-M42E', 'Hi-M82E', 'Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera'];
  var listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'];
  var listCategoryIcon = ['https://img.icons8.com/?size=100&id=91076&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=100062&format=png&color=475566','https://img.icons8.com/?size=100&id=108835&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566','https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=59749&format=png&color=475566','https://img.icons8.com/?size=100&id=110322&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RiveAppTheme.background,
        body: RefreshComponent(
            refreshController: _getController.refreshGuaranteeController,
            scrollController: _getController.scrollGuaranteeController,
            child: Column(
                children: [
                  SizedBox(
                      height: Get.height * 0.42,
                      width: Get.width,
                      child: Stack(
                          children: [
                            Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
                                    child: FadeInImage(
                                        image: NetworkImage(listImage[index]),
                                        placeholder: NetworkImage(listImage[index]),
                                        imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                        fit: BoxFit.cover
                                    )
                                )
                            ),
                            Positioned.fill(
                                child: Column(
                                    children: [
                                      AppBar(
                                          surfaceTintColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          centerTitle: true,
                                          elevation: 0,
                                          leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
                                          title: TextLarge(text: listImageName[index], color: AppColors.black),
                                          actions: [
                                            IconButton(icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
                                            IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
                                          ]
                                      ),
                                    ]
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), boxShadow: [
                      BoxShadow(
                          color: AppColors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3)
                      )
                    ]),
                    padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, top: Get.height * 0.015, bottom: Get.height * 0.01),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.backgroundApp,size: 15),
                              TextSmall(text: listStar[index], color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 13),
                              const Spacer(),
                              Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill)
                            ]
                          ),
                          SizedBox(height: Get.height * 0.01),
                          TextSmall(text: listImagePrice[index], color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 2),
                          SizedBox(height: Get.height * 0.01),
                          Row(
                              children: [
                                SizedBox(width: 110.w, child: TextSmall(text: 'Kafolat:', color: AppColors.blue, fontWeight: FontWeight.w500,fontSize: 14.sp)),
                                TextSmall(text: _getController.listPrice[index].toString(), color: AppColors.blue,fontWeight: FontWeight.w300,fontSize: 14.sp)
                              ]
                          ),
                          SizedBox(height: Get.height * 0.02),
                          TextSmall(text: 'Tavsif', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                          Container(
                            width: Get.width,
                            height: Get.height * 0.2,
                            padding: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02, top: Get.height * 0.01, bottom: Get.height * 0.01),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.grey, width: 1.w)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.15,
                                  child: FadingEdgeScrollView.fromScrollView(
                                    gradientFractionOnEnd: 0.5,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      controller: _getController.scrollControllerOk,
                                      itemBuilder: (context, index) => TextSmall(text: _getController.listImageInfo[index], color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 12),
                                      itemCount: _getController.listImageInfo.length,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => print('ok'),
                                  child: Row(
                                    children: [
                                      TextSmall(text: 'Batafsil', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
                                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill)
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          SizedBox(height: Get.height * 0.02),
                          TextSmall(text: 'Xususiyatlari', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                          Container(
                              width: Get.width,
                              height: Get.height * 0.2,
                              margin: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.03),
                              padding: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.02, top: Get.height * 0.01, bottom: Get.height * 0.01),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.grey, width: 1.w)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.15,
                                    child: FadingEdgeScrollView.fromScrollView(
                                      gradientFractionOnEnd: 0.5,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        controller: _getController.scrollControllerOk,
                                        itemBuilder: (context, index) => TextSmall(text: _getController.listImageInfo[index], color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 12),
                                        itemCount: _getController.listImageInfo.length,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () => print('ok'),
                                      child: Row(
                                        children: [
                                          TextSmall(text: 'Batafsil', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
                                          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill)
                                        ],
                                      )
                                  )
                                ],
                              )
                          ),
                          //Baxolash
                          TextSmall(text: 'Baxolash', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                          SizedBox(height: Get.height * 0.01),
                          RatingBar.builder(
                              initialRating: 3,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.sp,
                              itemPadding: EdgeInsets.symmetric(horizontal: 5.sp),
                              unratedColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                              itemBuilder: (context, _) =>
                              const Icon(TablerIcons.star_filled, color: AppColors.primaryColor),
                              onRatingUpdate: (rating) {

                              }
                          ),
                          //Sharxlar yozish
                          Container(
                              width: _getController.width.value,
                              padding: EdgeInsets.only(left: _getController.width.value * 0.03, right: _getController.width.value * 0.03),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2), width: 1)),
                              child: TextField(minLines: 1, maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface),
                                  decoration: InputDecoration(hintText: 'Kiriting'.tr,
                                      labelStyle: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                                      hintStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)), border: InputBorder.none)
                              )
                          ),

                        ]),
                  )
                ]
            )
        )
    );
  }
}