import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/product_item.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

import 'category_page.dart';

class DetailPage extends StatelessWidget {
  final int? index;
  final int? id;
  DetailPage({super.key, this.index, this.id});

  final GetController _getController = Get.put(GetController());


  @override
  Widget build(BuildContext context) {
    print('id: $id');
    ApiController().getProduct(id!, isCategory: false);
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: RefreshComponent(
            refreshController: _getController.refreshGuaranteeController,
            scrollController: _getController.scrollGuaranteeController,
            child: Obx(() => Column(
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
                                    foregroundColor: AppColors.blue,
                                    backgroundColor: Colors.grey.shade200,
                                    centerTitle: true,
                                    elevation: 0,
                                    title: _getController.productsModelDetail.value.result != null
                                        ? TextLarge(text: _getController.getCategoryName(_getController.productsModelDetail.value.result!.first.categoryId!).toString().toUpperCase(), color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 20.sp)
                                        : Skeletonizer(child: TextLarge(text: 'Nimadurda', color: AppColors.black, fontWeight: FontWeight.w500,fontSize: 20.sp)),
                                    actions: [
                                      IconButton(icon: Icon(Icons.share, color: AppColors.blue, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
                                      IconButton(icon: Icon(Icons.more_vert, color: AppColors.blue, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
                                    ]
                                )
                            ),
                            Expanded(
                                child: SizedBox(
                                    width: Get.width,
                                    child: FadeInImage(
                                        image: _getController.productsModelDetail.value.result != null ? NetworkImage(_getController.productsModelDetail.value.result!.first.photoUrl.toString()) : const AssetImage('assets/images/logo_back.png'),
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
                                        _getController.productsModelDetail.value.result != null
                                            ? TextLarge(text: _getController.productsModelDetail.value.result!.first.name.toString(), color: AppColors.blue, fontWeight: FontWeight.bold, maxLines: 2, fontSize: 30.sp)
                                            : Skeletonizer(child: TextLarge(text: 'Nimadurda', color: AppColors.blue, fontWeight: FontWeight.bold, maxLines: 2, fontSize: 30.sp)),
                                        _getController.productsModelDetail.value.result != null
                                            ? TextLarge(text: _getController.getCategoryName(_getController.productsModelDetail.value.result!.first.categoryId!).toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white, maxLines: 2, fontSize: 16.sp)
                                            : Skeletonizer(child: TextLarge(text: 'Nimadur', color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white, maxLines: 2, fontSize: 16.sp))
                                      ]
                                  ),
                                  _getController.productsModelDetail.value.result != null
                                      ? Container(padding: EdgeInsets.all(9.r), decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(100.r)), child: Icon(EneftyIcons.heart_outline, color: AppColors.white, size: 19.sp))
                                      : Skeletonizer(child: Icon(EneftyIcons.heart_outline, color: AppColors.white, size: 39.sp))
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
                                                _getController.productsModelDetail.value.result != null
                                                    ? Row(children: [Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: 15.sp), SizedBox(width: Get.width * 0.01), TextSmall(text: _getController.productsModelDetail.value.result!.first.rating != null ? _getController.productsModelDetail.value.result!.first.rating.toString() : '-', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)])
                                                    : Skeletonizer(child: Row(children: [Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: 15.sp), SizedBox(width: Get.width * 0.01), TextSmall(text: '289 ', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)])
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
                                                _getController.productsModelDetail.value.result != null
                                                    ? TextSmall(text: '${_getController.productsModelDetail.value.result!.first.warranty != null ? _getController.productsModelDetail.value.result!.first.warranty.toString() : '-'} kun', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                                    : Skeletonizer(child: TextSmall(text: 'Nimadur', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15))
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
                                                _getController.productsModelDetail.value.result != null
                                                    ? TextSmall(text: _getController.productsModelDetail.value.result!.first.brand != '' ? _getController.productsModelDetail.value.result!.first.brand.toString() : '-', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                                    : Skeletonizer(child: TextSmall(text: 'Nimadur', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15))
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
                        padding: EdgeInsets.only(top: Get.height * 0.01),
                        child: Column(
                          children: [
                            _getController.productsModelDetail.value.result != null
                                ? AnimatedSize(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Container(
                                height: _getController.fullText.value ? null : 105.h,
                                child: FadingEdgeScrollView.fromScrollView(
                                  gradientFractionOnEnd: 0.5,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    controller: _getController.scrollControllerOk,
                                    itemBuilder: (context, index) => TextSmall(
                                      text: _getController.productsModelDetail.value.result!.first.description ?? '-',
                                      color: RiveAppTheme.shadow,
                                      fontWeight: FontWeight.w400,
                                      maxLines: _getController.productsModelDetail.value.result!.first.description!.length,
                                      fontSize: 10,
                                    ),
                                    itemCount: 1,
                                  ),
                                ),
                              ),
                            )
                                : Skeletonizer(
                              child: SizedBox(
                                height: 105.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _getController.scrollControllerOk,
                                  itemBuilder: (context, index) => const TextSmall(
                                    text: 'text: _getController.productsModel.value.result![index].description!.toString(),',
                                    color: RiveAppTheme.shadow,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 1000,
                                    fontSize: 10,
                                  ),
                                  itemCount: 10,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _getController.fullText.value = !_getController.fullText.value;
                              },
                              child: Row(
                                children: [
                                  TextSmall(
                                    text: 'Batafsil',
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 1,
                                    fontSize: 14.sp,
                                  ),
                                  Icon(
                                    _getController.fullText.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: AppColors.blue,
                                    size: Theme.of(context).iconTheme.size,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.grey, thickness: 1),
                            SizedBox(height: Get.height * 0.01),
                            const TextSmall(text: 'Baxolash', color: AppColors.blue, fontWeight: FontWeight.bold),
                            SizedBox(height: Get.height * 0.01),
                            RatingBar.builder(
                                initialRating: _getController.productsModelDetail.value.result!= null ? _getController.productsModelDetail.value.result!.first.rating!.toDouble() : 0,
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
                                height: 345.h,
                                width: Get.width,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: [
                                          SizedBox(width: 35.w),
                                          if (_getController.productsModel.value.result != null)
                                            for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                              InkWell(
                                                onTap: () {
                                                  // Ensure the id exists
                                                  final productId = _getController.productsModel.value.result![index].id;
                                                  if (productId != null) {
                                                    Get.to(() => DetailPage(id: productId));
                                                  }
                                                },
                                                child: ProductItem(index: index),
                                              )
                                              //InkWell(onTap: () {Get.to(DetailPage(id: _getController.productsModel.value.result![index].id));}, child: ProductItem(index: index))
                                              //InkWell(onTap: () => print(_getController.productsModel.value.result![index].id), child: ProductItem(index: index))
                                        ]
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  SizedBox(height: Get.height * 0.1)
                ]
            ))
        )
    );
  }
}