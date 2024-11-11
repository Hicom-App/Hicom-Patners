import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../resource/colors.dart';
import '../filds/text_small.dart';
import '../product_item.dart';

class SkeletonProducts extends StatelessWidget {
  const SkeletonProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return  Skeletonizer(
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
                            TextButton(onPressed: () {}, child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.grey.withOpacity(0.9)))
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
                            for (int index = 0; index < 10; index++)
                              ProductItem(index: index)
                          ]
                      )
                  )
              )
            ]
        ));
  }

}