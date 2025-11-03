import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../companents/filds/text_small.dart';
import '../../../models/sample/partner_model.dart';
import '../../../models/sample/partner_models.dart';
import '../../../resource/colors.dart';
import '../controllers/partners_controller.dart';
import '../views/partners_detail_view.dart';

class PartnerCards extends GetView<PartnersController> {
  final dynamic partner;
  final int index;
  final bool isNearest;

  const PartnerCards({super.key, required this.partner, required this.index, required this.isNearest});

  @override
  Widget build(BuildContext context) {

    Get.put(PartnersDetailController());
    final currentPartner = partner.result![index];
    final todayWorkingDay = controller.getTodayWorkingDay(currentPartner.workingDays);
    final bool isOpenToday = todayWorkingDay?.isOpen == 1;
    final Color statusColor = todayWorkingDay != null ? (isOpenToday ? AppColors.green : AppColors.red) : AppColors.red;
    final String statusText = todayWorkingDay != null ? (isOpenToday ? 'Ochiq'.tr : 'Yopiq'.tr) : 'Yopiq'.tr;
    final bool hasWorkingDays = currentPartner.workingDays != null && currentPartner.workingDays!.isNotEmpty;
    final String openTime = todayWorkingDay?.openTime?.substring(0, 5) ?? '';
    final String closeTime = todayWorkingDay?.closeTime?.substring(0, 5) ?? '';


    return InkWell(
        onTap: () => Get.to(() => PartnersDetailView(index, statusText)),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.only(top: 16.h, bottom: 16.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColors.grey.withAlpha(100), width: 1),
                boxShadow: [BoxShadow(color: AppColors.grey.withAlpha(100), blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
            ),
            child: Column( // Expanded olib tashlandi
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.h,
                          decoration: BoxDecoration(color: AppColors.grey.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(partner.result![index].photoUrl.toString(), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(EneftyIcons.shop_bold, size: 32, color: AppColors.grey)))
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      children: [
                                        Expanded(child: TextSmall(text: partner.result![index].name.toString(), fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.black)),
                                        if (isNearest)
                                          Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(color: Colors.blue[50], border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(12)),
                                              child: TextSmall(text: 'Eng yaqin', fontSize: 10.sp, color: AppColors.blue, fontWeight: FontWeight.bold)
                                          )
                                      ]
                                  ),
                                  SizedBox(height: 4.h),
                                  TextSmall(text: partner.result![index].description.toString(), fontSize: 14.sp, color: AppColors.black70, maxLines: 2, overflow: TextOverflow.ellipsis)
                                ]
                            )
                        ),
                      ]
                  ),
                  const SizedBox(height: 12),
                  Row(
                      children: [
                        Icon(EneftyIcons.location_bold, size: 16.sp, color: AppColors.blue),
                        SizedBox(width: 4.w),
                        Flexible(child: TextSmall(text: '${partner.result![index].distance}', fontSize: 14.sp, color: AppColors.blue, overflow: TextOverflow.ellipsis)),
                        SizedBox(width: 16.w),
                        Icon(EneftyIcons.clock_2_bold, size: 16, color: statusColor),
                        SizedBox(width: 4.w),
                        Flexible(child: TextSmall(text: statusText, fontSize: 14.sp, color: statusColor, overflow: TextOverflow.ellipsis)),
                        SizedBox(width: 4.w),
                        if (hasWorkingDays && todayWorkingDay != null)
                          TextSmall(text: '($openTime - $closeTime)', fontSize: 14.sp, color: Colors.black, overflow: TextOverflow.ellipsis),
                      ]
                  ),
                  SizedBox(height: 12.h),
                  Row(
                      children: [
                        Expanded(
                            child: Row(
                                children: [
                                  Icon(EneftyIcons.call_bold, size: 16.sp, color: AppColors.black),
                                  SizedBox(width: 4.w),
                                  Expanded(child: Text(partner.result![index].phone.toString(), style: TextStyle(fontSize: 14.sp, color:AppColors.black), overflow: TextOverflow.ellipsis))
                                ]
                            )
                        ),
                        if (partner.result![index].rating == null || partner.result![index].rating != 0)
                          Expanded(
                            child: Row(
                                children: [
                                  Icon(EneftyIcons.star_bold, size: 16.sp, color: Colors.amber),
                                  SizedBox(width: 4.w),
                                  TextSmall(text: partner.result![index].rating.toStringAsFixed(1), fontSize: 14.sp, color: AppColors.black)
                                ]
                            )
                        )
                      ]
                  ),
                  SizedBox(height: 12.h),
                  TextSmall(text: partner.result![index].address.toString(), fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.black, maxLines: 2, overflow: TextOverflow.ellipsis)
                ]
            )
        )
    );
  }
}