import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/api_controller.dart';
import '../controllers/get_controller.dart';
import '../resource/colors.dart';
import 'filds/text_small.dart';
import 'home/chashe_image.dart';

class ProductItems extends StatelessWidget{
  final int index;
  final int i;
  final bool category;
  ProductItems({super.key, required this.index, required this.i, required this.category});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {

    var data = _getController.categoriesAllProductsModel.value.all![index].result![i];

    return _getController.categoriesAllProductsModel.value.all![index].result!.length > i ?
      Container(
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
                    ClipRRect(borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)), child: CacheImage(url: data.photoUrl.toString(), keys: data.id.toString())),
                    if (_getController.token != null && _getController.token.isNotEmpty)
                      Positioned(
                          right: 12.w,
                          top: 10.h,
                          child: InkWell(
                            //onTap: () => ApiController().addFavorites(int.parse(data.id.toString()), isProduct: data.favorite == 0 ? true : false).then((value) => _getController.updateCategoriesProductsModel(index, i, data.favorite == 0 ? 1 : 0)),
                              onTap: () => ApiController().addFavorites(int.parse(data.id.toString()), isProduct: data.favorite == 0 ? true : false).then((value) => _getController.updateFavoriteAllModels(data.id!.toInt(), data.favorite == 0 ? 1 : 0)),
                              child: Icon(data.favorite == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline, color: data.favorite == 1 ? Colors.red : Theme.of(context).colorScheme.onSurface, size: 20)
                          )
                      ),
                    if (data.isNew == 1)
                      Positioned(
                          left: 12.w,
                          top: 10.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(10.r)),
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
                        TextSmall(text: _getController.getCategoryName(int.parse(data.categoryId.toString())).toUpperCase(), color: AppColors.black,fontWeight: FontWeight.bold, fontSize: 15.sp),
                        TextSmall(text: data.name.toString(), color: AppColors.black70, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 12.sp),
                        Row(
                          children: [
                            Icon(EneftyIcons.dollar_circle_bold, color: AppColors.backgroundApp, size: 11.sp),
                            SizedBox(width: 5.w),
                            TextSmall(text: 'Кэшбэк:'.tr, color: AppColors.black, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp),
                            SizedBox(width: 5.w),
                           // TextSmall(text: '300${data.price} ${'so‘m'.tr}', color: AppColors.backgroundApp, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 10.sp),
                            TextSmall(text: '${data.cashback}', color: AppColors.backgroundApp, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 10.sp),
                          ],
                        ),
                        Row(
                            children: [
                              Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp, size: 11.sp),
                              SizedBox(width: 5.w),
                              TextSmall(text: '${'Baho'.tr}: ${data.rating?.toStringAsFixed(1) ?? '0.0'}', color: Colors.black87, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp),
                            ]
                        )
                      ]
                  )
              )
            ]
        )
    ) : const SizedBox();
  }
}