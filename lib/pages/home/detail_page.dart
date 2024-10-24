import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/product_item.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

import 'category_page.dart';

class DetailPage extends StatelessWidget {
  final int index;
  DetailPage({super.key, required this.index});

  final GetController _getController = Get.put(GetController());


  final List list = ['AI POE', 'NETWORK CABINET', 'HDD', 'PDU', 'CAMERA', 'ACSESSORIES', 'HDMI CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE'];
  final List listTitle = ['Jarayonda', 'Tasdiqlangan', 'To`langan','Rad etilgan'];
  final List listPrice = ['2 285 404', '224 614', '223 786', '1 272 102'];
  final List listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red];
  final List listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'];
  final List listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'PoE Switch', 'PoE Switch', 'PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera',];
  final List listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'Hi-M42E', 'Hi-M82E', 'Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera'];
  final List listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'];
  final List listCategoryIcon = ['https://img.icons8.com/?size=100&id=91076&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=100062&format=png&color=475566','https://img.icons8.com/?size=100&id=108835&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566','https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=59749&format=png&color=475566','https://img.icons8.com/?size=100&id=110322&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: RefreshComponent(
            refreshController: _getController.refreshGuaranteeController,
            scrollController: _getController.scrollGuaranteeController,
            child: Column(
                children: [
                  SizedBox(
                      height: Get.height * 0.37,
                      width: Get.width,
                      child: Column(
                          children: [
                            SizedBox(
                                width: Get.width,
                                child: AppBar(
                                    surfaceTintColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
                                    backgroundColor: Colors.grey.shade200,
                                    centerTitle: true,
                                    elevation: 0,
                                    title: TextLarge(
                                        //text: listImageName[index].toString().toUpperCase(),
                                        text: _getController.getCategoryName(_getController.productsModel.value.result![index].categoryId!).toString().toUpperCase(),
                                        color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500,fontSize: 20.sp),
                                    actions: [
                                      IconButton(icon: Icon(Icons.share, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
                                      IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
                                    ]
                                )
                            ),
                            //Expanded(child: Container(width: Get.width, decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(listImage[index]), fit: BoxFit.scaleDown))))
                            Expanded(
                                child: SizedBox(
                                  width: Get.width,
                                  child: FadeInImage(
                                    image: NetworkImage(_getController.productsModel.value.result![index].photoUrl.toString()),
                                    placeholder: const AssetImage('assets/images/logo_back.png'),
                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover)));},
                                    fit: BoxFit.cover
                                  )
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 10.h, top: 20.h),
                    decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, -10), blurRadius: 20)], color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLarge(
                                      //text: listImagePrice[index],
                                      text: _getController.productsModel.value.result![index].name.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, maxLines: 2, fontSize: 30.sp),
                                  TextLarge(
                                      //text: listImageName[index],
                                      text: _getController.getCategoryName(_getController.productsModel.value.result![index].categoryId!).toString(),
                                      color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white, maxLines: 2, fontSize: 16.sp)
                                ]
                              ),
                              Container(
                                padding: EdgeInsets.all(9.r),
                                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(100.r)),
                                child: Icon(EneftyIcons.heart_outline, color: AppColors.white, size: 19.sp)
                              )
                            ]
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Container(
                            width: Get.width,
                            height: 55.h,
                            decoration: BoxDecoration(color: AppColors.greys, borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextSmall(text: 'Baxo', color: AppColors.black70,fontSize: 10.sp),
                                      Row(
                                        children: [
                                          Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: 15.sp),
                                          SizedBox(width: Get.width * 0.01),
                                          TextSmall(
                                              //text: '3.9',
                                              text: _getController.productsModel.value.result![index].rating != null ? _getController.productsModel.value.result![index].rating.toString() : '0',
                                              color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                        ]
                                      )
                                    ]
                                  )
                                ),
                                const VerticalDivider(color: Colors.grey, thickness: 1, width: 20, indent: 10, endIndent: 10),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextSmall(text: 'Kafolat', color: AppColors.black70,fontSize: 10.sp),
                                      SizedBox(width: Get.width * 0.01),
                                      TextSmall(
                                          //text: '1 yil',
                                          text: '${_getController.productsModel.value.result![index].warranty != null ? _getController.productsModel.value.result![index].warranty.toString() : '0'} kun',
                                          color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                    ]
                                  )
                                ),
                                const VerticalDivider(color: Colors.grey, thickness: 1, width: 20, indent: 10, endIndent: 10),
                                Center(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextSmall(text: 'Brend', color: AppColors.black70,fontSize: 10.sp),
                                        SizedBox(width: Get.width * 0.01),
                                        TextSmall(text: 'Hicom', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                    ]
                                  )
                                )
                              ]
                            )
                          ),
                          SizedBox(height: Get.height * 0.02),
                          const TextSmall(text: 'Tavsif', color: AppColors.blue, fontWeight: FontWeight.bold),
                          Container(
                            width: Get.width,
                            height: 140.h,
                            padding: EdgeInsets.only(top: Get.height * 0.01),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 105.h,
                                  child: FadingEdgeScrollView.fromScrollView(
                                    gradientFractionOnEnd: 0.5,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      controller: _getController.scrollControllerOk,
                                      //itemBuilder: (context, index) => TextSmall(text: _getController.listImageInfo[index], color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 10),
                                      itemBuilder: (context, index) => TextSmall(
                                          text: _getController.productsModel.value.result![index].description!.toString(),
                                          color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 10),
                                      //itemCount: _getController.listImageInfo.length
                                      itemCount: _getController.productsModel.value.result![index].description!.length
                                    )
                                  )
                                ),
                                Row(
                                    children: [
                                      TextSmall(text: 'Batafsil', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, maxLines: 1,fontSize: 14.sp),
                                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill)
                                    ]
                                )
                              ]
                            )
                          ),
                          const Divider(color: Colors.grey, thickness: 1),
                          SizedBox(height: Get.height * 0.01),
                          const TextSmall(text: 'Baxolash', color: AppColors.blue, fontWeight: FontWeight.bold),
                          SizedBox(height: Get.height * 0.01),
                          RatingBar.builder(
                              //initialRating: 3,
                              initialRating: _getController.productsModel.value.result![index].rating != null ? _getController.productsModel.value.result![index].rating!.toDouble() : 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.sp,
                              itemPadding: EdgeInsets.symmetric(horizontal: 5.sp),
                              unratedColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                              itemBuilder: (context, _) =>
                              const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp),
                              onRatingUpdate: (rating) {}
                          )
                        ]
                    )
                  ),
                  Container(
                    color: AppColors.white,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                              margin: EdgeInsets.only(left: 25.w, top: 10.h),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextSmall(text: 'Tavsiya etiladi'.tr, color: Theme.of(context).colorScheme.onSurface),
                                    const Spacer(),
                                    TextButton(onPressed: () => Get.to(CategoryPage(index: 0)), child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.grey.withOpacity(0.9)))
                                  ]
                              )
                          )
                        ),
                        SizedBox(
                            height: 355.h,
                            width: Get.width,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(width: 35.w),
                                    if (_getController.productsModel.value.result != null)
                                      for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                        InkWell(onTap: () => Get.to(DetailPage(index: index)), child: ProductItem(index: index))
                                  ]
                                )
                            )
                        )
                      ]
                    )
                  ),
                  SizedBox(height: Get.height * 0.1)
                ]
            )
        )
    );
  }
}