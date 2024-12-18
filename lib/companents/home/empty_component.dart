import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/colors.dart';
import '../filds/text_small.dart';

class EmptyComponent extends StatelessWidget{
  const EmptyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Get.height * 0.7,
        width: Get.width,
        child: Center(child: TextSmall(text: 'Ma’lumotlar yo‘q', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16.sp)),
    );
  }
}