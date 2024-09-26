import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
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
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: Get.width * 0.03, // Horizontal spacing between items
                    mainAxisSpacing: Get.height * 0.04, // Vertical spacing between items
                    childAspectRatio: 0.74
                ),
                padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Get.to(DetailPage(index: index)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.r),
                                topLeft: Radius.circular(20.r),
                              ),
                              child: FadeInImage(
                                image: NetworkImage(_getController.listImage[index]),
                                placeholder: NetworkImage(_getController.listImage[index]),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.r),
                                        bottomRight: Radius.circular(10.r),
                                      ),
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: Icon(
                                index == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline,
                                color: index == 1 ? Colors.red : Theme.of(context).colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSmall(
                                text: _getController.listImageName[index],
                                color: AppColors.blue,
                                fontSize: 13,
                              ),
                              Row(
                                children: [
                                  TextSmall(
                                    text: _getController.listImagePrice[index],
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    EneftyIcons.star_bold,
                                    color: AppColors.backgroundApp,
                                    size: 11,
                                  ),
                                  TextSmall(
                                    text: _getController.listStar[index],
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 1,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
