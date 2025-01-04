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
  final int id;
  final int open;
  const CategoryPage({super.key, required this.id, required this.open});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GetController _getController = Get.put(GetController());

  void getData() {
    _getController.catSearchController.clear();
    /*if (widget.open == 0) {
      ApiController().getProducts(widget.id, isCategory: false, category: true);
    } else if (widget.open == 1) {
      ApiController().getProducts(0,isCategory: false, isFavorite: true, category: true);
    } else if (widget.open == 2) {
      ApiController().getProducts(0, isCategory: false, isFavorite: false, category: true, filter: 'category_id = ${widget.id}');
    }*/

    if (widget.open == 0) {
      ApiController().getProducts(widget.id, isCategory: false,category: true);
    } else if (widget.open == 1) {
      ApiController().getProducts(0,isCategory: false, isFavorite: true, category: true);
    } else if (widget.open == 2) {
      ApiController().getProducts(0, isCategory: false, category: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _getController.clearCategoryProductsModel();
    print('CategoryPage suuu');
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.open == 1) {
      ApiController().getProducts(0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(centerTitle: true, backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: widget.open == 0 ? _getController.getCategoryName(widget.id) : widget.open == 1 ? 'Sevimli mahsulotlar'.tr : 'Barcha mahsulotlar', color: AppColors.black, fontWeight: FontWeight.w500)),
        body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        onRefresh: () {
          _getController.catSearchController.clear();
          if (widget.open == 0) {
            ApiController().getProducts(widget.id, isCategory: false,category: true).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (widget.open == 1) {
            ApiController().getProducts(0,isCategory: false, isFavorite: true, category: true).then((_) => _getController.refreshCategoryController.refreshCompleted());
          } else if (widget.open == 2) {
            ApiController().getProducts(0, isCategory: false, category: true).then((_) => _getController.refreshCategoryController.refreshCompleted());
          }
        },
        child: Obx(() => Column(
            children: [
              SearchTextField(
                  controller: _getController.catSearchController,
                  margin: 20,
                  color: AppColors.grey.withOpacity(0.2),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      getData();
                      return;
                    }
                    debugPrint(value);
                    if (widget.open == 0) {
                      if (value.isNotEmpty) {
                        ApiController().getProducts(widget.id, isCategory: false, filter: 'name CONTAINS "${_getController.catSearchController.text}"',category: true);
                      }
                    } else if (widget.open == 1) {
                      if (value.isNotEmpty) {
                        ApiController().getProducts(0,isCategory: false, isFavorite: true, filter: '(name CONTAINS "${_getController.catSearchController.text}" OR category_name CONTAINS "${_getController.catSearchController.text}")', category: true);
                      }
                    } else if (widget.open == 2) {
                      if (value.isNotEmpty) {
                        ApiController().getProducts(0, isCategory: false , filter: 'name CONTAINS "${_getController.catSearchController.text}" OR category_name CONTAINS "${_getController.catSearchController.text}"', category: true);
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
                          itemBuilder: (context, index) => InkWell(
                            splashColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              onTap: () => Get.to(DetailPage(id: _getController.categoryProductsModel.value.result![index].id)), child: CatProductItem(index: index, isFavorite: widget.open == 1 ? true : false)),
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