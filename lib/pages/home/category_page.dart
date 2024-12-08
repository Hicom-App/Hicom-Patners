import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import '../../companents/cat_product_item.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/skeleton_favorites.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'detail_page.dart';

class CategoryPage extends StatelessWidget {
  final int index;
  final int open;
  CategoryPage({super.key, required this.index, required this.open});

  final GetController _getController = Get.put(GetController());

  void getData() {
    _getController.searchController.clear();
    if (open == 0) {
      ApiController().getProducts(_getController.categoriesModel.value.result![index].id!.toInt(), isCategory: false);
    } else if (open == 1) {
      ApiController().getProducts(0,isCategory: false, isFavorite: true);
    } else if (open == 2) {
      ApiController().getProducts(0, isCategory: false, isFavorite: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getController.clearCategoryProductsModel();
    getData();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(centerTitle: true, backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: open == 0 ? _getController.categoriesModel.value.result![index].name! : open == 1 ? 'Sevimli mahsulotlar'.tr : 'Barcha mahsulotlar', color: AppColors.black, fontWeight: FontWeight.w500)),
      body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        onRefresh: () {
          _getController.searchController.clear();
          if (open == 0) {
            ApiController().getProducts(_getController.categoriesModel.value.result![index].id!.toInt(), isCategory: false).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (open == 1) {
            ApiController().getProducts(0,isCategory: false, isFavorite: true).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (open == 2) {
            ApiController().getProducts(0, isCategory: false).then((_) => _getController.refreshCategoryController.refreshCompleted());
          }
        },
        child: Obx(() => Column(
            children: [
              SearchTextField(
                  margin: 20,
                  color: AppColors.grey.withOpacity(0.2),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      getData();
                      return;
                    }
                    debugPrint(value);
                    if (open == 0) {
                      if (value.isNotEmpty && value.length > 3) {
                        ApiController().getProducts(_getController.categoriesModel.value.result![index].id!.toInt(), isCategory: false, filter: 'name CONTAINS "${_getController.searchController.text}"');
                      }
                    } else if (open == 1) {
                      if (value.isNotEmpty && value.length > 3) {
                        ApiController().getProducts(0,isCategory: false, isFavorite: true, filter: '(name CONTAINS "${_getController.searchController.text}" OR category_name CONTAINS "${_getController.searchController.text}")');
                      }
                    } else if (open == 2) {
                      if (value.isNotEmpty && value.length > 3) {
                        ApiController().getProducts(0, isCategory: false , filter: 'name CONTAINS "${_getController.searchController.text}" OR category_name CONTAINS "${_getController.searchController.text}"');
                      }
                    }
                  }
              ),
              SizedBox(height: Get.height * 0.02),
              if (_getController.categoryProductsModel.value.result != null)
                if (_getController.categoryProductsModel.value.result!.isNotEmpty)
                  SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:_getController.getCrossAxisCount(), crossAxisSpacing: 0, mainAxisSpacing: 15.sp, childAspectRatio: 0.78),
                          padding: EdgeInsets.only(left: 25.w, right: 10.w),
                          itemBuilder: (context, index) => InkWell(onTap: () => Get.to(DetailPage(id: _getController.categoryProductsModel.value.result![index].id)), child: CatProductItem(index: index, isFavorite: open == 1 ? true : false)),
                          itemCount: _getController.categoryProductsModel.value.result!.length
                      )
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    width: Get.width,
                    height: Get.height * 0.65,
                    child: TextSmall(text: 'Ma’lumotlar yo‘q'.tr, color: AppColors.black, fontWeight: FontWeight.w500, maxLines: 2),
                  )
              else
                const SkeletonFavorites()
            ]
        ))
      )
    );
  }
}