import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../companents/cat_product_item.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'detail_page.dart';

class CategoryPage extends StatelessWidget {
  final int index;
  final int open;
  CategoryPage({super.key, required this.index, required this.open});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    if (open == 0) {
      ApiController().getProducts(_getController.categoriesModel.value.result![index].id!.toInt(), isCategory: false);
    } else if (open == 1) {
      ApiController().getProducts(0,isCategory: false, isFavorite: true);
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white,
          title: TextSmall(text: open == 0 ? _getController.categoriesModel.value.result![index].name! : 'Sevimli mahsulotlar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
      body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        child: Obx(() => Column(
            children: [
              SearchTextField(color: AppColors.grey.withOpacity(0.2)),
              SizedBox(height: Get.height * 0.02),
              if (_getController.categoryProductsModel.value.result != null)
                SizedBox(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:_getController.getCrossAxisCount(), crossAxisSpacing: 0, mainAxisSpacing: 15.sp, childAspectRatio: 0.78),
                        padding: EdgeInsets.only(left: 15.w, right: 5.w),
                        itemBuilder: (context, index) => InkWell(onTap: () => Get.to(DetailPage(id: _getController.categoryProductsModel.value.result![index].id)), child: CatProductItem(index: index)),
                        itemCount: _getController.categoryProductsModel.value.result!.length
                    )
                )
              else
                Skeletonizer(
                    child: SizedBox(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:_getController.getCrossAxisCount(), crossAxisSpacing: 0, mainAxisSpacing: 15.sp, childAspectRatio: 0.78),
                            padding: EdgeInsets.only(left: 15.w, right: 5.w),
                            itemBuilder: (context, index) => Container(
                                height: 225.h,
                                width: 165.w,
                                margin: EdgeInsets.only(right: 15.w),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 15.r, spreadRadius: 15.r, offset: const Offset(0, 0))]
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
                                                    image: const AssetImage('assets/images/logo_back.png'),
                                                    placeholder: const AssetImage('assets/images/logo_back.png'),
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image:AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                            Positioned(right: 12.w, top: 10.h, child: Icon(index == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline, color: index == 1 ? Colors.red : Theme.of(context).colorScheme.onSurface, size: 20))
                                          ]
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 13.w, right: 5.w),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextSmall(text: 'Asalomu alaykum', color: AppColors.black,fontWeight: FontWeight.bold, fontSize: 15.sp),
                                                TextSmall(text: 'salom', color: AppColors.black70, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 12.sp),
                                                Row(
                                                    children: [
                                                      SizedBox(width: 3.w),
                                                      Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp, size: 11.sp),
                                                      SizedBox(width: 5.w),
                                                      TextSmall(text: '2.2 * 2122 baxo', color: Colors.black87, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp)
                                                    ]
                                                )
                                              ]
                                          )
                                      )
                                    ]
                                )
                            ),
                            itemCount: 6
                        )
                    )
                )
            ]
        ))
      )
    );
  }
}