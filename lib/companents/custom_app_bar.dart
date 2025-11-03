import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../resource/colors.dart';
import 'filds/text_small.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? titleSize;
  final String? subtitle;
  final double? subtitleSize;
  final bool? isBack;
  final IconData? icon;
  final bool? isCenter;
  final Function? suffixOnTap;

  const CustomAppBar({super.key, required this.title, this.subtitle, this.isBack, this.icon, this.isCenter, this.titleSize, this.subtitleSize, this.suffixOnTap});

  @override
  Widget build(BuildContext context) => Container(
    width: Get.width,
    height: subtitle != null ? 350.h : 150.h,
    padding: EdgeInsets.only(top: 55.sp, left: 16, right: 16, bottom: 10.sp),
    decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(20)), image: DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.fill)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isCenter ?? false ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        if (isBack ?? false)
          Container(width: 45.sp, height: 45.sp, margin: EdgeInsets.only(right: isCenter ?? false ? 0 : 16.sp),
              child: IconButton(onPressed: () => Get.back(), icon: const Icon(EneftyIcons.arrow_left_3_outline, color: AppColors.white, size: 26))),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isCenter ?? false ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  TextSmall(text: title, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: titleSize ?? 20.sp),
                  if (subtitle != null)
                    const SizedBox(height: 4),
                  if (subtitle != null)
                    TextSmall(text: subtitle!, color: AppColors.white, fontSize: subtitleSize ?? 14.sp)
                ]
            )
        ),
        SizedBox(width: 45.sp, height: 45.sp, child: IconButton(onPressed: () {suffixOnTap?.call();}, icon: Icon(icon, color: AppColors.white, size: 26))),
      ]
    )
  );

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 100.h : 150.h);
}