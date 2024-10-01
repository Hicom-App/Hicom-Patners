import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_small.dart';
import '../../resource/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
            title: TextSmall(text: 'Bildirishnomalar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
        body: Column(
          children: [
            _buildListTile(icon: EneftyIcons.notification_bold, title: 'Bildirishnomalar'.tr, onTap: (){}, status: 1),
            _buildListTile(icon: EneftyIcons.stickynote_bold, title: 'Yangiliklar'.tr, onTap: (){}, status: 2),
            _buildListTile(icon: EneftyIcons.note_text_bold, title: 'So`rovnomalar'.tr, onTap: (){}, status: 2)
          ]
        )
    );
  }

  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color,required int status}) {
    color ??= Theme.of(Get.context!).brightness == Brightness.light ? AppColors.black : AppColors.white;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      margin: EdgeInsets.only(top: 13.h, left: 15.w, right: 15.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
      child: ListTile(
          onTap: onTap,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          leading: Icon(icon, color: status == 1 ? color : color.withOpacity(0.4)),
          title: Text(title, style: TextStyle(fontSize: 14.sp, color: status == 1 ? color : color.withOpacity(0.4))),
          trailing: status == 0 ? Icon(Icons.chevron_right, color: color)
              : status == 1 ? CupertinoSwitch(
            value: false,
            onChanged: (value) {},
            activeColor: AppColors.blue,
            trackColor: AppColors.grey.withOpacity(0.5),
            focusColor: AppColors.blue,
            thumbColor: AppColors.white,
            applyTheme: true,
          ) : CupertinoSwitch(
            value: false,
            onChanged: (value) {},
            activeColor: color.withOpacity(0.4),
            trackColor: AppColors.grey.withOpacity(0.5),
            focusColor: AppColors.greys,
            thumbColor: AppColors.greys,
            applyTheme: true,
          )
      ),
    );
  }

}