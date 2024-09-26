import 'package:enefty_icons/enefty_icons.dart';
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        surfaceTintColor: AppColors.white,
        title: TextSmall(text: 'Kategoriya'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      body: RefreshComponent(
        scrollController: _getController.scrollCategoryController,
        refreshController: _getController.refreshCategoryController,
        child: Column(
          children: [
            SearchTextField(color: AppColors.greys.withOpacity(0.4)),
            SizedBox(height: Get.height * 0.02),
            SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:_getController.getCrossAxisCount(),
                    crossAxisSpacing: Get.width * 0.03, // Horizontal spacing between items
                    mainAxisSpacing: Get.height * 0.04, // Vertical spacing between items
                    childAspectRatio: 0.74
                ),
                padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Get.to(DetailPage(index: index)),
                  child: ProductItem(index: index)
                ),
                itemCount: _getController.listImage.length,
              ),
            ),
          ]
        )
      )
    );
  }
}
