import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_small.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class SafetyPage extends StatelessWidget {
  SafetyPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
          foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
          surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
          title: TextSmall(text: 'Kirish va xavfsizlik'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
      body: Column(
        children: [
          _buildListTile(
              context: context,
              icon:  EneftyIcons.password_check_bold,
              color: Colors.black,
              title: 'Parolni o‘zgartirish'.tr,
              onTap: (){
                InstrumentComponents().bottomSheetChangePassword(context);
              }
          ),
          _buildListTile(
            context: context,
            icon:  EneftyIcons.profile_delete_bold,color: Colors.red,
            title: 'Hisobni o‘chirish'.tr,
            onTap: (){
              _getController.deleteTimer();
              InstrumentComponents().bottomSheetAccountsDelete(context);
            }
          )
        ]
      )
    );
  }
  Container _buildListTile({required BuildContext context, required IconData icon, required String title, required VoidCallback onTap, color}) {
    color ??= AppColors.black;
    return Container(
        height: 60.h,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        margin: const EdgeInsets.only(top: 13.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),

        /*child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Icon(icon, color: color),
            titleTextStyle: const TextStyle(fontFamily: 'Schyler'),
            leadingAndTrailingTextStyle: const TextStyle(fontFamily: 'Schyler'),
            title: Text(title, style: TextStyle(fontSize: 14, color: color, fontFamily: 'Schyler')),
            trailing: Icon(Icons.chevron_right, color: color)
        )*/
        child: InkWell(
          onTap: onTap,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                SizedBox(width: 10.w),
                Text(title, style: TextStyle(fontSize: 14, color: color, fontFamily: 'Schyler')),
                const Spacer(),
                Icon(Icons.chevron_right, color: color)
              ])
        )
    );
  }
}