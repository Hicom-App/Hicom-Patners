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

class CategoryPage extends StatefulWidget {
  final int index;
  final int open;
  const CategoryPage({super.key, required this.index, required this.open});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GetController _getController = Get.put(GetController());

  void getData() {
    _getController.searchController.clear();
    if (widget.open == 0) {
      ApiController().getProducts(_getController.categoriesModel.value.result![widget.index].id!.toInt(), isCategory: false);
    } else if (widget.open == 1) {
      ApiController().getProducts(0,isCategory: false, isFavorite: true);
    } else if (widget.open == 2) {
      ApiController().getProducts(0, isCategory: false, isFavorite: false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getController.clearCategoryProductsModel();
    getData();
  }

  @override
  void dispose() {
    Future.microtask(() {
      if (_getController.searchController.text.isNotEmpty){
        _getController.searchController.clear();
        _getController.refreshController.refreshCompleted();
        _getController.clearCategoriesProductsModel();
        _getController.clearProductsModel();
        _getController.clearCategoriesModel();
        ApiController().getCategories();
      }
    });
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(centerTitle: true, backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: widget.open == 0 ? _getController.categoriesModel.value.result![widget.index].name! : widget.open == 1 ? 'Sevimli mahsulotlar'.tr : 'Barcha mahsulotlar', color: AppColors.black, fontWeight: FontWeight.w500)),
        body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        onRefresh: () {
          _getController.searchController.clear();
          if (widget.open == 0) {
            ApiController().getProducts(_getController.categoriesModel.value.result![widget.index].id!.toInt(), isCategory: false).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (widget.open == 1) {
            ApiController().getProducts(0,isCategory: false, isFavorite: true).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (widget.open == 2) {
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
                    if (widget.open == 0) {
                      if (value.isNotEmpty && value.length > 3) {
                        ApiController().getProducts(_getController.categoriesModel.value.result![widget.index].id!.toInt(), isCategory: false, filter: 'name CONTAINS "${_getController.searchController.text}"');
                      }
                    } else if (widget.open == 1) {
                      if (value.isNotEmpty && value.length > 3) {
                        ApiController().getProducts(0,isCategory: false, isFavorite: true, filter: '(name CONTAINS "${_getController.searchController.text}" OR category_name CONTAINS "${_getController.searchController.text}")');
                      }
                    } else if (widget.open == 2) {
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
                          itemBuilder: (context, index) => InkWell(onTap: () => Get.to(DetailPage(id: _getController.categoryProductsModel.value.result![index].id)), child: CatProductItem(index: index, isFavorite: widget.open == 1 ? true : false)),
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