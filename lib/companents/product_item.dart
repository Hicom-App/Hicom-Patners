import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/skletons/product_item_skeleton.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import '../controllers/get_controller.dart';
import '../resource/colors.dart';
import 'filds/text_small.dart';
import 'home/chashe_image.dart';

class ProductItem extends StatelessWidget{
  final int index;
  ProductItem({super.key, required this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return _getController.productsModel.value.result != null ? _getController.productsModel.value.result!.isNotEmpty
        ? Container(
        height: 245.h,
        width: 165.w,
        margin: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 15.r, spreadRadius: 15.r, offset: const Offset(0, 0))]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [
                    Positioned(right: 0.w, top: 0.h, child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                            image: const DecorationImage(image: AssetImage('assets/images/foncard.jpg'), fit: BoxFit.cover)
                        ),
                        child: SizedBox(height: 162.h, width: 165.w))
                    ),
                    //Positioned.fill(child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/foncard.jpg'), fit: BoxFit.fitHeight)), child: SizedBox(height: 140.h, width: 1.w))),
                    ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                        child: CacheImage(
                          url: _getController.productsModel.value.result![index].photoUrl.toString(),
                          keys:  _getController.productsModel.value.result![index].id.toString()
                        )
                    ),
                    if (_getController.token != null && _getController.token.isNotEmpty)
                      Positioned(right: 12.w, top: 10.h, child: InkWell(onTap: () => ApiController().addFavorites(_getController.productsModel.value.result![index].id!.toInt(), isProduct: _getController.productsModel.value.result![index].favorite == 0 ? true : false).then((value) => _getController.updateFavoriteAllModels(_getController.productsModel.value.result![index].id!.toInt(), _getController.productsModel.value.result![index].favorite == 0 ? 1 : 0)), child: Icon(_getController.productsModel.value.result![index].favorite == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline, color: _getController.productsModel.value.result![index].favorite == 1 ? Colors.red : AppColors.black, size: 20.sp))),
                    if (_getController.productsModel.value.result![index].isNew == 1)
                      Positioned(
                          left: 12.w,
                          top: 10.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                                color: AppColors.secondaryColor,
                                borderRadius: BorderRadius.circular(10.r)
                            ),
                            child: TextSmall(text: 'Yangi', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 10.sp),
                        )
                    )
                  ]
              ),
              Padding(
                  padding: EdgeInsets.only(left: 13.w, right: 5.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextSmall(text: _getController.getCategoryName(int.parse(_getController.productsModel.value.result![index].categoryId.toString())).toUpperCase(), color: AppColors.black,fontWeight: FontWeight.bold, fontSize: 15.sp),
                        TextSmall(text: _getController.productsModel.value.result![index].name.toString(), color: AppColors.black70, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 12.sp),
                        Row(
                          children: [
                            Icon(EneftyIcons.dollar_circle_bold, color: AppColors.backgroundApp, size: 11.sp),
                            SizedBox(width: 5.w),
                            TextSmall(text: 'Кэшбэк:'.tr, color: AppColors.black, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp),
                            SizedBox(width: 5.w),
                            TextSmall(text: '${_getController.productsModel.value.result![index].cashback}', color: AppColors.backgroundApp, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 10.sp),
                          ],
                        ),
                        Row(
                            children: [
                              Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp, size: 11.sp),
                              SizedBox(width: 5.w),
                              TextSmall(text: '${'Baho'.tr}: ${_getController.productsModel.value.result![index].rating == null ? '0': _getController.productsModel.value.result![index].rating.toStringAsFixed(1)}', color: Colors.black87, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp),
                            ]
                        )
                      ]
                  )
              )
            ]
        )
    )
        : const SizedBox()
        : ProductItemSkeleton(index: index);
  }

}