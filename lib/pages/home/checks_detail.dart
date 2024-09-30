import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';

import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class ChecksDetail extends StatelessWidget{
  ChecksDetail({super.key});

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
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 10),
            TextSmall(text: 'Muvaffaqiyatli o‘tkazildi',fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
            SizedBox(height: 5.h),
            /*Text(
              'Yak, 6 Iyun 2022',
              style: TextStyle(color: Colors.grey),
            ),*/
            TextSmall(text: 'Yak, 6 Iyun 2022',fontSize: 14.sp, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                //color: Colors.grey[200],

                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Fee',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Treatment name'),
                      Text('Braces Application', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Clinic name'),
                      Text('Avicena Clinic', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '10 000.00',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'so`m',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaction detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bill ID'),
                      Text('#BILL00124'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reservation ID'),
                      Text('#RSVA0011'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method'),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.black54),
                          SizedBox(width: 5),
                          Text('**** **** **** 4204'),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking fee'),
                      Text('10 000.00'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax'),
                      Text('\$0'),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('10 000.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                //primary: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: AppColors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              ),
              child: TextSmall(text: 'Bosh sahifa', color: AppColors.white)),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

}