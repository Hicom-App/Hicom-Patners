import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/get_controller.dart';
import '../resource/colors.dart';
import 'filds/text_small.dart';

class ProductItem extends StatelessWidget{
  final int index;
  ProductItem({super.key, required this.index});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.h,
        width: 135.w,
        margin: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2), width: 1)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                        child: FadeInImage(
                            image: NetworkImage(_getController.listImage[index]),
                            placeholder: NetworkImage(_getController.listImage[index]),
                            imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                            fit: BoxFit.cover
                        )
                    ),
                    Positioned(right: 5.w, top: 5.h, child: Icon(index == 1 ? EneftyIcons.heart_bold : EneftyIcons.heart_outline, color: index == 1 ? Colors.red : Theme.of(context).colorScheme.onSurface, size: 20))
                  ]
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 5.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextSmall(text: _getController.listImageName[index], color: AppColors.blue, fontSize: 13.sp),
                        TextSmall(text: _getController.listImagePrice[index], color: Theme.of(context).colorScheme.onSurface),
                        Row(
                            children: [
                              Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp, size: 11.sp),
                              TextSmall(text: _getController.listStar[index], color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 10.sp)
                            ]
                        )
                      ]
                  )
              )
            ])
    );
  }

}