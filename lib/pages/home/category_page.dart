import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/product_item.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'detail_page.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
        surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        title: TextSmall(text: 'Kategoriya'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)
      ),
      body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        child: Column(
          children: [
            SearchTextField(color: AppColors.grey.withOpacity(0.2)),
            SizedBox(height: Get.height * 0.02),
            SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:_getController.getCrossAxisCount(), crossAxisSpacing: 0, mainAxisSpacing: 15.sp, childAspectRatio: 0.78),
                padding: EdgeInsets.only(left: 15.w, right: 5.w),
                itemBuilder: (context, index) => InkWell(onTap: () => Get.to(DetailPage(index: index)), child: ProductItem(index: index)),
                //itemCount: _getController.listImage.length
                itemCount: _getController.productsModel.value.result!.length
              )
            )
          ]
        )
      )
    );
  }
}