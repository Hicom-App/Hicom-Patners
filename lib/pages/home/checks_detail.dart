import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:intl/intl.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class ChecksDetail extends StatelessWidget{
  final int id;
  final int operation;
  final String dateCreated;
  final String name;
  final String firstName;
  final int? cardId;
  final int amount;
  final String description;
  final String? cardNo;
  final String? cardHolder;

  ChecksDetail({super.key, required this.operation, required this.dateCreated, required this.name, required this.firstName, required this.amount, required this.description, this.cardId, required this.id, this.cardNo, this.cardHolder});

  final GetController _getController = Get.put(GetController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
          onPressed: () {
            Get.back();
          }
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
            onPressed: () {}
          )
        ]
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(operation == 0 ? TablerIcons.circle_plus_filled : operation == 1 ? TablerIcons.clock_filled : operation == 2 ? TablerIcons.circle_check_filled : TablerIcons.xbox_x_filled, color: operation == 3 ? AppColors.red : operation == 1 ? AppColors.backgroundApp : operation == 2 ? AppColors.green : AppColors.blue, size: 80.sp),
            SizedBox(height: 10.h),
            TextSmall(text: operation == 0 ? 'Balansni to‘ldirish' : operation == 1 ? 'Jarayonda' : operation == 2 ? 'Muvaffaqiyatli o‘tkazildi' : 'Rad etildi', fontSize: 18.sp, color: operation == 3 ? AppColors.red : operation == 1 ? AppColors.backgroundApp : AppColors.black, fontWeight: FontWeight.w500),
            SizedBox(height: 5.h),
            if (dateCreated.isNotEmpty)
              TextSmall(text: DateFormat('dd MMMM yyyy').format(DateTime.parse(dateCreated)), fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).brightness == Brightness.light ? AppColors.greys : AppColors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSmall(text: 'Tranzaksiya tafsilotlari',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Karta raqami',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white),
                          SizedBox(width: 5.h),
                          TextSmall(
                              text: cardNo.toString(), fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                        ]
                      ),
                    ]
                  ),
                  SizedBox(height: 5.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSmall(text: 'Qabul qiluvchi',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                        TextSmall(text: _getController.getMaskedName(cardHolder.toString()),fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                      ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'To‘langan vaqti', fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(
                          text: DateFormat('HH:mm').format(DateTime.parse(dateCreated)),
                          fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Tranzaksiya raqami',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                      TextSmall(text: id.toString(),fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400)
                    ]
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Jami',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                      TextSmall(text: '$amount.00',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                    ]
                  )
                ]
              )
            ),
            SizedBox(height: 20.h),
            if (description.isNotEmpty && description != 'null')
              Container(
                width: Get.width,
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSmall(text: 'Qo`shimcha',fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, maxLines: 300),
                      SizedBox(height: 10.h),
                      TextSmall(text: description, fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, maxLines: 10)
                    ]
                )
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), backgroundColor: AppColors.blue, padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 15.h)),
              child: TextSmall(text: 'Orqaga', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1,fontSize: 16.sp)
            ),
            SizedBox(height: 30.h)
          ]
        )
      )
    );
  }
}