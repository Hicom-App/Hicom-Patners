import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../resource/colors.dart';
import 'filds/text_small.dart';

class LanguageSelectItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String text;
  final Function() onTap;
  const LanguageSelectItem({super.key, required this.index, required this.text, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: index == selectedIndex ? Get.width * 0.7 : Get.width * 0.6,
        height: 50.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
        decoration: BoxDecoration(
          border: index == selectedIndex ? null : Border.all(color: AppColors.grey, width: 0.2),
          color: AppColors.greys,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: index == selectedIndex ? [const BoxShadow(color: AppColors.grey, spreadRadius: 3, blurRadius: 10, offset: Offset(0, 3))] : null,
        ),
        child: TextSmall(
          text: text,
          color: AppColors.black,
          fontSize: index == selectedIndex ? 24.sp : 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
