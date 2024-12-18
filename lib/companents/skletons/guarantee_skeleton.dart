import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../resource/colors.dart';
import '../filds/search_text_field.dart';
import '../filds/text_small.dart';

class GuaranteeSkeleton extends StatelessWidget{
  const GuaranteeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
   return Skeletonizer(
       child: Column(
           children: [
             SizedBox(height: Get.height * 0.01),
             for (int i = 0; i < 5; i++)
               Container(
                   margin: EdgeInsets.only(bottom: 12.h, top: 12.h, left: 15.w, right: 15.w),
                   decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                   child: Column(
                       children: [
                         if (i == 0 || i == 2 || i == 3)
                           Container(
                             margin: EdgeInsets.only(bottom: 20.h),
                             padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                             child: TextSmall(
                               text: i == 0 ? 'Bugun' : i == 2 ? 'Kecha' : '20.01.2024',
                               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                               fontWeight: FontWeight.w400,
                             ),
                           ),
                         Container(
                             padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 9.h),
                             width: Get.width,
                             decoration: BoxDecoration(
                                 color: Theme.of(context).brightness == Brightness.light ? Colors.white : AppColors.black70,
                                 boxShadow: [
                                   BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0))
                                 ],
                                 borderRadius: BorderRadius.circular(18.r)
                             ),
                             child: Row(
                                 children: [
                                   Container(
                                       margin: EdgeInsets.only(right: 15.w),
                                       width: Get.width * 0.36,
                                       height: Get.height * 0.13,
                                       child: Stack(
                                           children: [
                                             Positioned(
                                               width: 2,
                                               height: Get.height * 0.11,
                                               child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(10.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))]))),
                                             ),
                                             Positioned(
                                               right: 0,
                                               width: 2,
                                               height: Get.height * 0.11,
                                               child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(20.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))]),)),
                                             ),
                                             Positioned.fill(
                                                 child: Container(
                                                     decoration: const BoxDecoration(color: AppColors.white),
                                                     child: ClipRRect(
                                                         borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                                         child: FadeInImage(
                                                             image: const NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'),
                                                             placeholder: const AssetImage('assets/images/logo_back.png'),
                                                             imageErrorBuilder: (context, error, stackTrace) {
                                                               return Container(
                                                                   decoration: BoxDecoration(
                                                                     image: const DecorationImage(image: AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover),
                                                                     borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                                                                   )
                                                               );
                                                             },
                                                             fit: BoxFit.cover
                                                         )
                                                     )
                                                 )
                                             )
                                           ]
                                       )
                                   ),
                                   Expanded(
                                       child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                 children: [
                                                   SizedBox(
                                                       width: 110.w,
                                                       child: TextSmall(
                                                         text: 'Tovar nomi:',
                                                         color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 18.sp,
                                                       )
                                                   ),
                                                   const Spacer(),
                                                   InkWell(
                                                     //onTap: () => ApiController().deleteWarrantyProduct(warranty.id!.toInt()),
                                                     child: Icon(Icons.delete, color: AppColors.red, size: 18.sp),
                                                   ),
                                                   SizedBox(width: 12.w),
                                                 ]
                                             ),
                                             SizedBox(height: 12.h),
                                             Row(
                                                 children: [
                                                   SizedBox(
                                                       width: 75.w,
                                                       child: TextSmall(text: 'Kategoriya:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)
                                                   ),
                                                   SizedBox(
                                                       width: Get.width * 0.225,
                                                       child: TextSmall(text: 'kategoriya nomi', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp)
                                                   )
                                                 ]
                                             ),
                                             Row(
                                                 children: [
                                                   SizedBox(
                                                       width: 75.w,
                                                       child: TextSmall(text: 'Qo`shilgan:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)
                                                   ),
                                                   SizedBox(
                                                       width: Get.width * 0.225,
                                                       child: TextSmall(text: '12.12.2024', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp)
                                                   )
                                                 ]
                                             ),
                                             Row(
                                                 children: [
                                                   SizedBox(
                                                       width: 75.w,
                                                       child: TextSmall(text: 'Kafolat:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)
                                                   ),
                                                   SizedBox(
                                                       width: Get.width * 0.225,
                                                       child: TextSmall(text: '12.12.2024', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp)
                                                   )
                                                 ]
                                             ),
                                             SizedBox(height: 6.h),
                                             Row(
                                                 children: [
                                                   Container(
                                                       width: 80.w,
                                                       padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                       decoration: BoxDecoration(color: AppColors.greys, borderRadius: BorderRadius.circular(11.r)),
                                                       child: Center(child: TextSmall(text: 'Faol emas', color: i == 1 ? AppColors.white : AppColors.white, fontSize: 11.sp))
                                                   ),
                                                   const Spacer(),
                                                   Icon(Icons.archive_outlined, color: AppColors.black70, size: 23.sp),
                                                   SizedBox(width: 11.w)
                                                 ]
                                             )
                                           ]
                                       )
                                   )
                                 ]
                             )
                         )
                       ]
                   )
               )
           ]
       )
   );
  }

}